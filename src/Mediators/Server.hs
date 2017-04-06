module Mediators.Server where

import Mediator

server = Mediator {..}
  where
    key = $(this)
    build base = do
#ifdef __GHCJS__
      return (ws "10.0.1.18" 8080 *:* base)
#else
      ws <- websocket unlimited
      return (state ws *:* base)
#endif
    prime = do
#ifdef __GHCJS__
      wsInitialize
#else
      initializeClientWS "10.0.1.18" 8080 "/"
#endif
      return ()
