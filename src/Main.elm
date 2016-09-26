module Main exposing (..)

import Model exposing (Model, model)
import View exposing (view)
import Update exposing (Msg, update)
import Subscriptions exposing (subscriptions)

import Html.App as App

main : Program Never
main =
  App.program
    { init = init
    , view = View.view
    , update = update
    , subscriptions = subscriptions
    }

init : (Model, Cmd Msg)
init =
  (model, Cmd.none)
