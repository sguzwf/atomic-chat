module API.Implementation where

import Atomic hiding (Msg,sub)

import API.Definition
import Data.Msg
import Mediators.Broadcaster

chatImpl = Impl chatAPI msgs reqs
  where
    msgs = handlePublish   <:> none
    reqs = handleSubscribe <:> none

handlePublish = accepts pub $ \done edm ->
  case edm of
    Left _  -> return ()
    Right m -> lift_ $ do
      user <- get
      now  <- millis
      publishMsg (Msg user now m)

handleSubscribe = responds sub $ \done edu ->
  case edu of
    Left _         -> return ()
    Right (rsp,un) -> lift_ $ do
      put un
      Right unsubscribe <- demand =<< subscribeMsgs (lift_ . rsp . Right)
      onSelfShutdown (liftIO unsubscribe)
