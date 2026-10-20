-- | Some additional operations on monads.
--
--   Author: Michael Hanus, Fredrik Wieczerkowski
--   Version: September 2026

module Control.Monad.Extra where

import Control.Monad       ( unless, when )

-- | Same as `concatMap`, but for a monadic function.
concatMapM :: Monad m => (a -> m [b]) -> [a] -> m [b]
concatMapM f xs = concat <$> mapM f xs

-- | Same as `mapM` but with an additional accumulator threaded through.
mapAccumM :: Monad m => (a -> b -> m (a, c))
          -> a -> [b] -> m (a, [c])
mapAccumM _ s []       = return (s, [])
mapAccumM f s (x : xs) = f s x >>= (\(s', x') -> (mapAccumM f s' xs) >>=
                                     (\(s'', xs') -> return (s'', x' : xs')))

-- | Monadic version of `unless` where the condition is defined by a
--   monadic operation.
unlessM :: Monad m => m Bool -> m () -> m ()
unlessM cact act = do cond <- cact
                      unless cond act

-- | Monadic version of `when` where the condition is defined by a
--   monadic operation.
whenM :: Monad m => m Bool -> m () -> m ()
whenM cact act = do cond <- cact
                    when cond act

-- | Monadic version of `if` where the condition is defined by a
--   monadic operation.
ifM :: Monad m => m Bool -> m a -> m a -> m a
ifM mb mt mf = do b <- mb
                  if b then mt else mf
