module Data.Username where

import Atomic

newtype Username = Username Txt
  deriving (Eq,Generic,ToJSON,FromJSON,FromTxt,ToTxt)
instance Identify Username
