-- Copyright (C) 2026 Bel Esprit D'Accord Irrevocable Trust / SnapKitty Collective Limited
-- SPDX-License-Identifier: AGPL-3.0-only. Also subject to the SnapKitty Opaque License (dual license).
-- See LICENSE and SNAPKITTY_OPAQUE_LICENSE.md (repository root and curry/).
--
-- LRD-REC-v1 reader/writer (research/CONTRACTS.md).
--
--   record    ::= "LRD-REC-v1\n" field*
--   field     ::= <len(key)> ":" key <len(value)> ":" value "\n"
--
-- Lengths are UTF-8 byte counts. Keys are sorted bytewise ascending with no
-- duplicates; values contain no newline.
--
-- A *stream* (curry-module convention, see curry/GRAPH-FORMAT.md) is the plain
-- concatenation of zero or more serialized records. Because every record
-- starts with the magic line and every field line starts with a digit, the
-- record boundaries are unambiguous.

module LrdRec
  ( Record, magic, parseStream, serializeRecord, serializeStream
  , field, fieldOr, utf8Length
  ) where

import Data.Char (isDigit)
import Data.List (sortBy)

type Record = [(String, String)]

magic :: String
magic = "LRD-REC-v1"

-- | UTF-8 byte length of one code point.
utf8Char :: Char -> Int
utf8Char c
  | n < 0x80    = 1
  | n < 0x800   = 2
  | n < 0x10000 = 3
  | otherwise   = 4
 where n = fromEnum c

utf8Length :: String -> Int
utf8Length = foldr (\c n -> utf8Char c + n) 0

-- | Take characters until exactly n UTF-8 bytes are consumed.
takeBytes :: Int -> String -> Maybe (String, String)
takeBytes n s
  | n == 0    = Just ([], s)
  | n < 0     = Nothing
  | otherwise = case s of
      []     -> Nothing
      (c:cs) -> do (a, rest) <- takeBytes (n - utf8Char c) cs
                   return (c : a, rest)

readLen :: String -> Either String (Int, String)
readLen s = case span isDigit s of
  ([], _)         -> Left "expected decimal length"
  (ds, ':' : rest)
    | length ds > 1 && head ds == '0' -> Left ("length with leading zero: " ++ ds)
    | otherwise -> Right (foldl (\a c -> a * 10 + (fromEnum c - 48)) 0 ds, rest)
  (ds, _)         -> Left ("expected ':' after length " ++ ds)

parseField :: String -> Either String ((String, String), String)
parseField s = do
  (kl, r1) <- readLen s
  (k, r2)  <- maybe (Left "key shorter than declared length") Right (takeBytes kl r1)
  (vl, r3) <- readLen r2
  (v, r4)  <- maybe (Left "value shorter than declared length") Right (takeBytes vl r3)
  if '\n' `elem` k || '\n' `elem` v
    then Left ("newline inside key/value of field " ++ k)
    else case r4 of
      ('\n' : r5) -> Right ((k, v), r5)
      _           -> Left ("missing newline after field " ++ k)

parseFields :: String -> Either String (Record, String)
parseFields s = case s of
  (c:_) | isDigit c -> do (f, rest)   <- parseField s
                          (fs, rest') <- parseFields rest
                          return (f : fs, rest')
  _                 -> Right ([], s)

checkSorted :: Record -> Either String Record
checkSorted r
  | any (null . fst) r = Left "empty key (rejected by CONTRACTS v1.1)"
  | otherwise = go r >> return r
 where
  go xs = case xs of
    ((k1, _) : rest@((k2, _) : _))
      | k1 < k2   -> go rest
      | k1 == k2  -> Left ("duplicate key " ++ k1)
      | otherwise -> Left ("keys not sorted: " ++ k1 ++ " before " ++ k2)
    _ -> Right ()

-- | Parse a stream of LRD-REC-v1 records. Fails (Left) on the first defect.
parseStream :: String -> Either String [Record]
parseStream s
  | null s    = Right []
  | otherwise = case splitAt (length magic + 1) s of
      (hdr, rest)
        | hdr == magic ++ "\n" -> do
            (fs, rest') <- parseFields rest
            r  <- checkSorted fs
            rs <- parseStream rest'
            return (r : rs)
        | otherwise -> Left "expected 'LRD-REC-v1' header line"

serializeField :: (String, String) -> String
serializeField (k, v) =
  show (utf8Length k) ++ ":" ++ k ++ show (utf8Length v) ++ ":" ++ v ++ "\n"

-- | Canonical serialization: keys sorted bytewise ascending. (For the code
--   points used by UTF-8, Curry's String order coincides with byte order.)
serializeRecord :: Record -> String
serializeRecord r =
  magic ++ "\n" ++ concatMap serializeField (sortBy (\a b -> fst a <= fst b) r)

serializeStream :: [Record] -> String
serializeStream = concatMap serializeRecord

field :: String -> Record -> Maybe String
field = lookup

fieldOr :: String -> String -> Record -> String
fieldOr d k r = maybe d id (lookup k r)
