module Site where

import Organism

import Pages.Chat

data Routes = ChatR deriving Eq

runApp = run Organism {..}
  where
    site = $(this)
    root = Nothing
    build = return
    prime = return ()
    routes = dispatch ChatR
    pages ChatR = return home

home = page _Head _Chat

_Head = static "Head" $
  head
    [ title "Atomic Chat"
    ]
