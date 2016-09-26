module Subscriptions exposing (subscriptions)

import Model exposing (Model)
import Update exposing (..)

import Time exposing (Time, second)
import WebSocket

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Time.every second Tick
    , WebSocket.listen "ws://echo.websocket.org" NewMessage
    ]
