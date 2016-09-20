module Main exposing (..)

import Styles exposing (..)

import Html exposing (..)
import Svg exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Svg.Attributes exposing (..)
import Html.Events exposing (..)

import Random exposing (generate, int)
import Time exposing (Time, second)
import Json.Decode as Json
import Http
import Task
import String
import WebSocket

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
  , topic : String
  , gifUrl : String
  , isFetching : Bool
  , time : Time
  , chatInput : String
  , messages : List String
  }

model : Model
model =
  { content = ""
  , counter = 0
  , name = ""
  , password = ""
  , passwordCheck = ""
  , diceFace = 1
  , topic = "cats"
  , gifUrl = ""
  , isFetching = False
  , time = 0
  , chatInput = ""
  , messages = []
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
  | MorePlease
  | FetchSucceed String
  | FetchFail Http.Error
  | Tick Time
  | ChatInput String
  | Send
  | NewMessage String


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
      ({ model | diceFace = newFace }, Cmd.none)
    MorePlease ->
      ({ model | isFetching = True }, getRandomGif model.topic)
    FetchSucceed newUrl ->
      ({ model | gifUrl = newUrl, isFetching = False }, Cmd.none)
    FetchFail _ ->
      ({ model | isFetching = False }, Cmd.none)
    Tick newTime ->
      ({ model | time = newTime }, Cmd.none)
    ChatInput input ->
      ({ model | chatInput = input }, Cmd.none)
    Send ->
      (model, WebSocket.send "ws://echo.websocket.org" model.chatInput)
    NewMessage message ->
      ({ model | messages = (message :: model.messages)}, Cmd.none)


getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)

decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Time.every second Tick
    , WebSocket.listen "ws://echo.websocket.org" NewMessage
    ]

-- VIEW

view : Model -> Html Msg
view model =
  div [ Html.Attributes.style  container ]
    [ div [ box ++ container |> Html.Attributes.style ]
    [ div [ Html.Attributes.style heading ] [Html.text "Counter"]
        , button [ onClick Decrement, Html.Attributes.style item ] [ Html.text "-" ]
        , div [ Html.Attributes.style item ] [ model.counter |> toString |> Html.text ]
        , button [ onClick Increment, Html.Attributes.style item ] [ Html.text "+" ]
        , div [ [("width", "100%")] ++ centerContent |> Html.Attributes.style ]
            [ button [ onClick Reset, Html.Attributes.style item ] [ Html.text "Restart" ]
            ]
      ]
    , div [ box ++ column |> Html.Attributes.style ]
        [ div [ Html.Attributes.style heading ] [Html.text "Inverted text"]
        , input [ Html.Attributes.style item, placeholder "Input some Html.text", onInput Change ] []
        , div [] [ model.content |> String.reverse |> Html.text ]
        ]
    , div [ box ++ container |> Html.Attributes.style ]
        [ div [ Html.Attributes.style heading ] [Html.text "Login"]
        , input [ Html.Attributes.style item, Html.Attributes.type' "text", placeholder "Name", onInput Name ] []
        , input [ Html.Attributes.style item, Html.Attributes.type' "password", placeholder "Password", onInput Password ] []
        , input [ Html.Attributes.style item, Html.Attributes.type' "password", placeholder "Re-enter Password", onInput PasswordCheck ] []
        , viewValidation model
        ]
    , div [ box ++ column |> Html.Attributes.style ]
        [ div [ Html.Attributes.style heading ] [Html.text "Dice roller"]
        , div [ centerContent ++ [("width", "100%")] |> Html.Attributes.style ]
            [ h1 [ item ++ dice |> Html.Attributes.style, onClick Roll ] [ model.diceFace |> toString |> Html.text ]
            ]
        ]
    , div [ Html.Attributes.style box ]
        [ div [ Html.Attributes.style heading ] [ Html.text model.topic ]
        , gifOrLoading model
        , button [ onClick MorePlease ] [ Html.text "Moar!!!" ]
        ]
    , div [ Html.Attributes.style box ]
        [ div [ Html.Attributes.style heading ] [Html.text "Clock"]
        , clock model
        ]
    , div [ Html.Attributes.style box ]
      [ div [ Html.Attributes.style heading ] [ Html.text "Chat" ]
      , div [] (List.map viewMessage model.messages)
      , input [ onInput ChatInput ] []
      , button [ onClick Send ] [ Html.text "Send" ]
      ]
    ]

viewMessage : String -> Html msg
viewMessage msg =
  div [] [ Html.text msg ]

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
    div [ Html.Attributes.style [("color", color)] ] [ Html.text message ]

gifOrLoading : Model -> Html Msg
gifOrLoading model =
  if model.isFetching then
    div [] [ Html.text "Loading . . . " ]
  else img [ src model.gifUrl ] []

clock : Model -> Html Msg
clock model =
  let
    angle =
      turns (Time.inMinutes model.time)

    handX =
      toString (50 + 40 * cos angle)

    handY =
      toString (50 + 40 * sin angle)
  in
    Svg.svg [ viewBox "0 0 100 100", Svg.Attributes.width "300px" ]
      [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
      , line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "#023963" ] []
      ]
