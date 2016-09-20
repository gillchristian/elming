module Main exposing (..)

import Styles exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Random exposing (generate, int)

main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL

type alias Model =
  { content : String
  , counter : Int
  , name : String
  , password : String
  , passwordCheck : String
  , diceFace : Int
  }

model : Model
model =
  { content = ""
  , counter = 0
  , name = ""
  , password = ""
  , passwordCheck = ""
  , diceFace = 1
  }

init : (Model, Cmd Msg)
init =
  (model, Cmd.none)

-- UPDATE

type Msg
  = Increment
  | Decrement
  | Reset
  | Change String
  | Name String
  | Password String
  | PasswordCheck String
  | Roll
  | NewFace Int


update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Increment ->
      ({ model | counter = model.counter + 1 }, Cmd.none)
    Decrement ->
      ({ model | counter = model.counter - 1 }, Cmd.none)
    Reset ->
      ({ model | counter = 0 }, Cmd.none)
    Change newContent ->
      ({ model | content = newContent }, Cmd.none)
    Name name ->
      ({ model | name = name }, Cmd.none)
    Password password ->
      ({ model | password = password }, Cmd.none)
    PasswordCheck password ->
      ({ model | passwordCheck = password }, Cmd.none)
    Roll ->
      (model, generate NewFace (int 1 6))
    NewFace newFace ->
      ({model | diceFace = newFace}, Cmd.none)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- VIEW

view : Model -> Html Msg
view model =
  div [ style  container ]
    [ div [ box ++ container |> style ]
    [ div [ style heading ] [text "Counter"]
        , button [ onClick Decrement, style item ] [ text "-" ]
        , div [ style item ] [ model.counter |> toString |> text ]
        , button [ onClick Increment, style item ] [ text "+" ]
        , div [ [("width", "100%")] ++ centerContent |> style ]
            [ button [ onClick Reset, style item ] [ text "Restart" ]
            ]
      ]
    , div [ box ++ column |> style ]
        [ div [ style heading ] [text "Inverted text"]
        , input [ style item, placeholder "Input some text", onInput Change ] []
        , div [] [ model.content |> String.reverse |> text ]
        ]
    , div [ box ++ container |> style ]
        [ div [ style heading ] [text "Login"]
        , input [ style item, type' "text", placeholder "Name", onInput Name ] []
        , input [ style item, type' "password", placeholder "Password", onInput Password ] []
        , input [ style item, type' "password", placeholder "Re-enter Password", onInput PasswordCheck ] []
        , viewValidation model
        ]
    , div [ box ++ column |> style ]
        [ div [ style heading ] [text "Dice roller"]
        , div [ centerContent ++ [("width", "100%")] |> style ] 
            [ h1 [ item ++ dice |> style, onClick Roll ] [ model.diceFace |> toString |> text ]
            ]
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
