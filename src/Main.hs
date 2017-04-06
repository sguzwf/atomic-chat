module Main where

#ifdef __GHCJS__
import Site
#else
import Server
#endif

main = runApp
