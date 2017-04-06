module Pages.Chat where

import Control.Arrow
import Construct hiding (sub,subscribe,publish)

import API.Definition
import Data.Msg
import Data.Username
import Mediators.Server

data ChatState = ChatState
  { csInput :: Txt
  , csMessages :: [Msg]
  , csUsername :: Username
  , csNameSubmitted :: Bool
  } deriving Eq

defaultChatState = ChatState "" [] "" False

addMessage m = updates $ \cs -> cs { csMessages = m:csMessages cs }
setUsername un = updates $ \cs -> cs { csUsername = Username un }
setInput m = updates $ \cs -> cs { csInput = m }
setSubmitted = updates $ \cs -> cs { csNameSubmitted = True }

_usernamePrompt =
  [ label [ ] "Name:"
  , input [ onInput setUsername ]
  , button [ onClick subscribe ] "Set Username"
  ]

_chatInterface cs =
  [ label [ ] "Message:"
  , input [ val (csInput cs), onInput setInput ]
  , button [ onClick publish ] "Submit"
  , hashed div [] $ map (mTime &&& _message) (csMessages cs)
  ]

_message m =
  div "message"
    [ span [] (fromTxt . toTxt $ mUser m)
    , "@" -- this becomes a simple DOM TextNode
    , span [] (fromTxt . formatTime . fromMillis $ mTime m)
    , ": "
    , span [] (fromTxt . toTxt $ mText m)
    ]

formatTime :: Double -> Txt
formatTime =
#ifndef __GHCJS__
  toTxt
#else
  formatTime_js

foreign import javascript unsafe
  "$r = new Date($1).toLocaleTimeString()" formatTime_js :: Double -> Txt
#endif

publish = void $ do
  cs <- gets
  setInput ""
  apiMessageWith chatAPI server pub (csInput cs)

subscribe = void $ do
  cs <- gets
  setSubmitted
  apiRequestWith chatAPI server sub (csUsername cs) $ \done ->
    mapM_ $ \m -> lift (addMessage m)

_Chat = Construct {..}
  where
    key = $(this)
    build = return
    prime = return ()
    model = defaultChatState
    render cs =
      div [] $
        if csNameSubmitted cs then
          _chatInterface cs
        else
          _usernamePrompt
