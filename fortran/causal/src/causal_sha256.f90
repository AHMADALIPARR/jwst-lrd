! Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
! Dual-licensed: AGPL-3.0-only plus SnapKitty Opaque License.
! SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
!
! causal_sha256: FIPS 180-4 SHA-256 over a byte string (Fortran character, one byte
! per character).  32-bit words are held in int64 and masked after every operation so
! that no signed overflow can occur.
module causal_sha256
  use, intrinsic :: iso_fortran_env, only: int64
  implicit none
  private
  public :: sha256_hex

  integer(int64), parameter :: M32 = int(z'FFFFFFFF', int64)
  integer(int64), parameter :: K(0:63) = [ &
    int(z'428a2f98', int64), int(z'71374491', int64), int(z'b5c0fbcf', int64), int(z'e9b5dba5', int64), &
    int(z'3956c25b', int64), int(z'59f111f1', int64), int(z'923f82a4', int64), int(z'ab1c5ed5', int64), &
    int(z'd807aa98', int64), int(z'12835b01', int64), int(z'243185be', int64), int(z'550c7dc3', int64), &
    int(z'72be5d74', int64), int(z'80deb1fe', int64), int(z'9bdc06a7', int64), int(z'c19bf174', int64), &
    int(z'e49b69c1', int64), int(z'efbe4786', int64), int(z'0fc19dc6', int64), int(z'240ca1cc', int64), &
    int(z'2de92c6f', int64), int(z'4a7484aa', int64), int(z'5cb0a9dc', int64), int(z'76f988da', int64), &
    int(z'983e5152', int64), int(z'a831c66d', int64), int(z'b00327c8', int64), int(z'bf597fc7', int64), &
    int(z'c6e00bf3', int64), int(z'd5a79147', int64), int(z'06ca6351', int64), int(z'14292967', int64), &
    int(z'27b70a85', int64), int(z'2e1b2138', int64), int(z'4d2c6dfc', int64), int(z'53380d13', int64), &
    int(z'650a7354', int64), int(z'766a0abb', int64), int(z'81c2c92e', int64), int(z'92722c85', int64), &
    int(z'a2bfe8a1', int64), int(z'a81a664b', int64), int(z'c24b8b70', int64), int(z'c76c51a3', int64), &
    int(z'd192e819', int64), int(z'd6990624', int64), int(z'f40e3585', int64), int(z'106aa070', int64), &
    int(z'19a4c116', int64), int(z'1e376c08', int64), int(z'2748774c', int64), int(z'34b0bcb5', int64), &
    int(z'391c0cb3', int64), int(z'4ed8aa4a', int64), int(z'5b9cca4f', int64), int(z'682e6ff3', int64), &
    int(z'748f82ee', int64), int(z'78a5636f', int64), int(z'84c87814', int64), int(z'8cc70208', int64), &
    int(z'90befffa', int64), int(z'a4506ceb', int64), int(z'bef9a3f7', int64), int(z'c67178f2', int64) ]

contains

  pure integer(int64) function rotr(x, n)
    integer(int64), intent(in) :: x
    integer, intent(in) :: n
    rotr = iand(ior(shiftr(x, n), shiftl(x, 32 - n)), M32)
  end function rotr

  pure function sha256_hex(msg) result(hex)
    character(len=*), intent(in) :: msg
    character(len=64) :: hex
    integer(int64) :: h(0:7), w(0:63), a, b, c, d, e, f, g, hh, t1, t2, s0, s1, ch, mj
    integer(int64) :: bitlen
    integer :: nbytes, padlen, i, j, blk
    integer, allocatable :: buf(:)
    character(len=16), parameter :: digits = '0123456789abcdef'

    h = [int(z'6a09e667', int64), int(z'bb67ae85', int64), int(z'3c6ef372', int64), &
         int(z'a54ff53a', int64), int(z'510e527f', int64), int(z'9b05688c', int64), &
         int(z'1f83d9ab', int64), int(z'5be0cd19', int64)]
    nbytes = len(msg)
    padlen = nbytes + 1
    do while (mod(padlen, 64) /= 56)
      padlen = padlen + 1
    end do
    allocate(buf(0:padlen + 7))
    buf = 0
    do i = 1, nbytes
      buf(i - 1) = iachar(msg(i:i))
    end do
    buf(nbytes) = 128
    bitlen = 8_int64 * int(nbytes, int64)
    do i = 0, 7
      buf(padlen + 7 - i) = int(iand(shiftr(bitlen, 8 * i), 255_int64))
    end do

    do blk = 0, (padlen + 8) / 64 - 1
      do j = 0, 15
        i = blk * 64 + 4 * j
        w(j) = ior(ior(shiftl(int(buf(i), int64), 24), shiftl(int(buf(i + 1), int64), 16)), &
                   ior(shiftl(int(buf(i + 2), int64), 8), int(buf(i + 3), int64)))
      end do
      do j = 16, 63
        s0 = ieor(ieor(rotr(w(j - 15), 7), rotr(w(j - 15), 18)), shiftr(w(j - 15), 3))
        s1 = ieor(ieor(rotr(w(j - 2), 17), rotr(w(j - 2), 19)), shiftr(w(j - 2), 10))
        w(j) = iand(w(j - 16) + s0 + w(j - 7) + s1, M32)
      end do
      a = h(0); b = h(1); c = h(2); d = h(3); e = h(4); f = h(5); g = h(6); hh = h(7)
      do j = 0, 63
        s1 = ieor(ieor(rotr(e, 6), rotr(e, 11)), rotr(e, 25))
        ch = ieor(iand(e, f), iand(ieor(e, M32), g))
        t1 = iand(hh + s1 + ch + K(j) + w(j), M32)
        s0 = ieor(ieor(rotr(a, 2), rotr(a, 13)), rotr(a, 22))
        mj = ieor(ieor(iand(a, b), iand(a, c)), iand(b, c))
        t2 = iand(s0 + mj, M32)
        hh = g; g = f; f = e
        e = iand(d + t1, M32)
        d = c; c = b; b = a
        a = iand(t1 + t2, M32)
      end do
      h(0) = iand(h(0) + a, M32); h(1) = iand(h(1) + b, M32)
      h(2) = iand(h(2) + c, M32); h(3) = iand(h(3) + d, M32)
      h(4) = iand(h(4) + e, M32); h(5) = iand(h(5) + f, M32)
      h(6) = iand(h(6) + g, M32); h(7) = iand(h(7) + hh, M32)
    end do

    do i = 0, 7
      do j = 0, 7
        hex(8 * i + j + 1:8 * i + j + 1) = &
          digits(int(iand(shiftr(h(i), 28 - 4 * j), 15_int64)) + 1:int(iand(shiftr(h(i), 28 - 4 * j), 15_int64)) + 1)
      end do
    end do
  end function sha256_hex

end module causal_sha256
