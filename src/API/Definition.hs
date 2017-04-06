{-# language UndecidableInstances #-}
module API.Definition where

import Atomic hiding (sub)

import Data.Msg
import Data.Username

data Sub
sub = Proxy :: Proxy Sub
instance Request Sub where
  type Req Sub = Username
  type Rsp Sub = Msg

data Pub
pub = Proxy :: Proxy Pub
instance Message Pub where
  type M Pub = Txt

chatAPI = api msgs reqs
  where
    msgs = pub <:> none
    reqs = sub <:> none
