module Update exposing (..)

import Model exposing (Model)

import Random exposing (generate, int)
import Time exposing (Time)
import Http
import Json.Decode as Json
import Task
import WebSocket

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
