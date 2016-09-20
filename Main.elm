module Main exposing (..)

import Styles exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String

main : Program Never
main =
  App.beginnerProgram { model = model, view = view, update = update }

-- MODEL

type alias Model =
  { content : String
  , counter : Int
  , name : String
  , password : String
  , passwordCheck : String
  }

model :Model
model =
  { content = ""
  , counter = 0
  , name = ""
  , password = ""
  , passwordCheck = ""
  }

-- UPDATE

type Msg
  = Increment
  | Decrement
  | Reset
  | Change String
  | Name String
  | Password String
  | PasswordCheck String


update: Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      { model | counter = model.counter + 1 }
    Decrement ->
      { model | counter = model.counter - 1 }
    Reset ->
      { model | counter = 0 }
    Change newContent ->
      { model | content = newContent }
    Name name ->
      { model | name = name }
    Password password ->
      { model | password = password }
    PasswordCheck password ->
      { model | passwordCheck = password }

-- VIEW

view : Model -> Html Msg
view model =
  div [ style  container ]
    [ div [  box ++  container |> style ]
        [ button [ onClick Decrement, style  item ] [ text "-" ]
        , div [ style  item ] [ model.counter |> toString |> text ]
        , button [ onClick Increment, style  item ] [ text "+" ]
        , div [ [("width", "100%")] ++  centerContent |> style ]
            [
              button [ onClick Reset, style  item ] [ text "Restart" ]
            ]
      ]
    , div [style  box]
        [ input [ placeholder "Input some text", onInput Change ] []
        , div [] [ model.content |> String.reverse |> text ]
        ]
    , div [style box]
        [ input [ type' "text", placeholder "Name", onInput Name ] []
        , input [ type' "password", placeholder "Password", onInput Password ] []
        , input [ type' "password", placeholder "Re-enter Password", onInput PasswordCheck ] []
        , viewValidation model
        ]
    ]

viewValidation : Model -> Html Msg
viewValidation model =
  let
    (color, message) =
      if String.isEmpty model.password || String.isEmpty model.passwordCheck then
        ("", "")
      else if model.password == model.passwordCheck then
        ("green", "OK!!!")
      else
        ("red", "Passwords do not match!!!")
  in
    div [ style [("color", color)] ] [ text message ]
