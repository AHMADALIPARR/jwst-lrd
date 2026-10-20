-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
-- Licensed under AGPL-3.0-only plus the SnapKitty Opaque License (dual license, intentional).
-- See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md at the repository root.
--
-- Data-parallel simplicial boundary operators (mirrors fortran/topology).
-- Inputs are canonical (ascending) vertex tuples in canonical row/column order
-- plus stored orientations, exactly as exported by the Fortran reference.
-- Entry [sigma : face_i] = (-1)^i * orient(sigma) * orient(face_i), where face_i
-- omits sorted vertex i.
--
-- Inline smoke tests precede each entry point (the shared-fixture tests are
-- generated into fixtures/topology_fixtures_test.fut by tests/topology/run.sh).

def sign_of (i: i64): i32 = if i % 2 == 0 then 1 else -1

-- does face equal simp with sorted position i removed?
def omit_matches [k][k1] (face: [k]i64) (simp: [k1]i64) (i: i64): bool =
  and (tabulate k (\t -> face[t] == simp[if t < i then t else t + 1]))

-- dense boundary matrix d_k : C_k -> C_{k-1}; one independent task per entry
def boundary_impl [m][k][n][k1] (fv: [m][k]i64) (fo: [m]i32)
                                (sv: [n][k1]i64) (so: [n]i32): [m][n]i32 =
  let fv = assert (k1 == k + 1) fv
  in tabulate_2d m n (\r c ->
       loop acc = 0i32 for i < k1 do
         if omit_matches fv[r] sv[c] i then acc + sign_of i * so[c] * fo[r] else acc)

def matmul [a][b][c] (x: [a][b]i32) (y: [b][c]i32): [a][c]i32 =
  let yt = transpose y
  in map (\row -> map (\col -> i32.sum (map2 (*) row col)) yt) x

def powmod (b0: i64) (e0: i64) (p: i64): i64 =
  let (r, _, _) =
    loop (r, b, e) = (1i64, b0 % p, e0) while e > 0 do
      ((if e % 2 == 1 then (r * b) % p else r), (b * b) % p, e / 2)
  in r

def modp (x: i64) (p: i64): i64 = ((x % p) + p) % p

-- exact rank over GF(p), p prime < 2^31: sequential over columns, parallel pivot
-- search (reduce) and parallel row elimination (map) within a column step
def rank_modp [m][n] (p: i64) (a0: [m][n]i64): i64 =
  let a = map (map (\x -> modp x p)) a0
  let (_, r) =
    loop (a, r) = (a, 0i64) for c < n do
      if r >= m then (a, r) else
      let piv = reduce i64.min m (tabulate m (\i -> if i >= r && a[i, c] != 0 then i else m))
      in if piv == m then (a, r) else
      let inv = powmod a[piv, c] (p - 2) p
      let prow = map (\x -> (x * inv) % p) a[piv]
      let a' = tabulate m (\i ->
                 if i == r then prow
                 else if i == piv then (let f = a[r, c] in map2 (\x y -> modp (x - f * y) p) a[r] prow)
                 else if i > r && a[i, c] != 0 then (let f = a[i, c] in map2 (\x y -> modp (x - f * y) p) a[i] prow)
                 else a[i])
      in (a', r + 1)
  in r

-- ==
-- entry: boundary
-- input { [[0i64],[1i64],[2i64]] [1i32,1i32,1i32] [[0i64,1i64],[0i64,2i64],[1i64,2i64]] [1i32,1i32,1i32] }
-- output { [[-1i32,-1i32,0i32],[1i32,0i32,-1i32],[0i32,1i32,1i32]] }
entry boundary [m][k][n][k1] (fv: [m][k]i64) (fo: [m]i32) (sv: [n][k1]i64) (so: [n]i32): [m][n]i32 =
  boundary_impl fv fo sv so

-- ==
-- entry: rank_gfp
-- input { 2i64 [[0i64],[1i64],[2i64]] [1i32,1i32,1i32] [[0i64,1i64],[0i64,2i64],[1i64,2i64]] [1i32,1i32,1i32] }
-- output { 2i64 }
entry rank_gfp [m][k][n][k1] (p: i64) (fv: [m][k]i64) (fo: [m]i32) (sv: [n][k1]i64) (so: [n]i32): i64 =
  rank_modp p (map (map i64.i32) (boundary_impl fv fo sv so))

-- d_{k-1} o d_k as a parallel matrix product; returns (nonzeros, max |entry|)
-- ==
-- entry: ddcheck
-- input { [[0i64],[1i64],[2i64]] [1i32,1i32,1i32] [[0i64,1i64],[0i64,2i64],[1i64,2i64]] [1i32,1i32,1i32] [[0i64,1i64,2i64]] [1i32] }
-- output { 0i64 0i64 }
entry ddcheck [a][k0][m][k][n][k1] (v0: [a][k0]i64) (o0: [a]i32) (v1: [m][k]i64) (o1: [m]i32)
                                   (v2: [n][k1]i64) (o2: [n]i32): (i64, i64) =
  let d1 = boundary_impl v0 o0 v1 o1
  let d2 = boundary_impl v1 o1 v2 o2
  let flat = flatten (matmul d1 d2)
  in (i64.sum (map (\x -> if x != 0 then 1 else 0) flat),
      reduce i64.max 0 (map (\x -> i64.i32 (i32.abs x)) flat))
