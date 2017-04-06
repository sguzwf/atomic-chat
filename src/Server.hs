module Server where

import Population hiding (Msg)
import Presence hiding (Msg)

import API.Implementation
import Data.Username

import Site
import Data.Text.IO as T

runApp = run Population {..}
  where
    key = $(this)
    ip = "10.0.1.18"
    port = 8080
    build = return
    prime = liftIO $ do
      index <- renderDynamicSystemBootstrap home "/main.js"
      T.writeFile "./index.html" index
    presence = newPresence

newPresence _ = Presence {..}
  where
    build base = return (state (Username "") *:* base)
    prime = do
      chatEndpoints <- enact chatImpl
      return ()
