-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to the SnapKitty Opaque License (dual license).
-- See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md (repository root and curry/).
--
-- Minimal deterministic s-expression printer (grammar in curry/GRAPH-FORMAT.md).

module SExpr (SX(..), render, sym, str, tag) where

import Data.Char (isAlphaNum)
import Data.List (intercalate)

-- | A = atom (symbol, printed bare if it is a valid symbol, otherwise quoted),
--   S = string (always quoted), L = list.
data SX = A String | S String | L [SX]

sym :: String -> SX
sym = A

str :: String -> SX
str = S

-- | (name x1 x2 ...)
tag :: String -> [SX] -> SX
tag n xs = L (A n : xs)

symChar :: Char -> Bool
symChar c = isAlphaNum c || c `elem` "-_.:/+<>=*"

quote :: String -> String
quote s = "\"" ++ concatMap esc s ++ "\""
 where esc c = case c of
         '"'  -> "\\\""
         '\\' -> "\\\\"
         _    -> [c]

atom :: SX -> String
atom (A s) | not (null s) && all symChar s && head s /= '"' = s
           | otherwise = quote s
atom (S s) = quote s
atom (L _) = error "atom of list"

compact :: SX -> String
compact x = case x of
  L xs -> "(" ++ unwords (map compact xs) ++ ")"
  _    -> atom x

-- | Lists whose compact form fits in 100 columns stay on one line; longer
--   lists put the head and leading atoms on the first line and each further
--   element on its own line, indented by two spaces per level.
render :: SX -> String
render x = go 0 x ++ "\n"
 where
  go ind e = case e of
    L xs | length (compact e) + ind > 100 ->
      let (hd, rest) = span isAtom xs
      in "(" ++ unwords (map compact hd)
         ++ concatMap (\c -> "\n" ++ replicate (ind + 2) ' ' ++ go (ind + 2) c) rest
         ++ ")"
    _ -> compact e
  isAtom e = case e of
    L _ -> False
    _   -> True
