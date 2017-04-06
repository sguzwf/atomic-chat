module Data.Msg where

import Atomic hiding (Msg)

import Data.Username

data Msg = Msg
  { mUser :: Username
  , mTime :: Millis
  , mText :: Txt
  } deriving (Eq,Generic,ToJSON,FromJSON)
