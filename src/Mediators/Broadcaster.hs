module Mediators.Broadcaster where

import Mediator

import Data.Msg

broadcaster = Mediator {..}
  where
    key = $(this)
    build base = do
      n :: Network Msg <- network
      return (state n *:* base)
    prime = return ()

subscribeMsgs f = connectWith broadcaster get f

publishMsg m = syndicateWith broadcaster get m
