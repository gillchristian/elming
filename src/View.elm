module View exposing (view)

import Model exposing (Model)
import Update exposing (..)
import Styles exposing (..)

import Html exposing (..)
import Svg exposing (..)
import Html.Attributes as HtmlAtt exposing (..)
import Svg.Attributes as SvgAtt exposing (..)
import Html.Events exposing (..)
import Time exposing (Time)
import String

-- VIEW

view : Model -> Html Msg
view model =
  div [ HtmlAtt.style  container ]
    [ counterBox model.counter
    , invertedTextBox model.content
    , login model.password model.passwordCheck
    , diceBox model.diceFace
    , gifBox model.isFetching model.topic model.gifUrl
    , clockBox model.time
    , chatBox model.messages
    ]

counterBox : Int -> Html Msg
counterBox counter =
  div [ box ++ container |> HtmlAtt.style ]
    [ div [ HtmlAtt.style heading ] [Html.text "Counter"]
    , button [ onClick Decrement, HtmlAtt.style item ] [ Html.text "-" ]
    , div [ HtmlAtt.style item ] [ counter |> toString |> Html.text ]
    , button [ onClick Increment, HtmlAtt.style item ] [ Html.text "+" ]
    , div [ [("width", "100%")] ++ centerContent |> HtmlAtt.style ]
      [ button [ onClick Reset, HtmlAtt.style item ] [ Html.text "Restart" ]
      ]
    ]

invertedTextBox : String -> Html Msg
invertedTextBox content =
  div [ box ++ column |> HtmlAtt.style ]
    [ div [ HtmlAtt.style heading ] [Html.text "Inverted text"]
    , input [ HtmlAtt.style item
            , placeholder "Input some text"
            , onInput Change
            ] []
    , div [] [ content |> String.reverse |> Html.text ]
    ]

login : String -> String -> Html Msg
login password passwordCheck =
  div [ box ++ container |> HtmlAtt.style ]
    [ div [ HtmlAtt.style heading ] [Html.text "Login"]
    , input [ HtmlAtt.style item
            , HtmlAtt.type' "text"
            , placeholder "Name"
            , onInput Name
            ] []
    , input [ HtmlAtt.style item
            , HtmlAtt.type' "password"
            , placeholder "Password"
            , onInput Password
            ] []
    , input [ HtmlAtt.style item
            , HtmlAtt.type' "password"
            , placeholder "Re-enter Password"
            , onInput PasswordCheck
            ] []
    , viewValidation password passwordCheck
    ]

viewValidation : String -> String -> Html Msg
viewValidation password passwordCheck =
  let
    (color, message) =
      if String.isEmpty password || String.isEmpty passwordCheck then
        ("", "")
      else if password == passwordCheck then
        ("green", "OK!!!")
      else
        ("red", "Passwords do not match!!!")
  in
    div [ HtmlAtt.style [("color", color)] ] [ Html.text message ]

diceBox : Int -> Html Msg
diceBox diceFace =
  div [ box ++ column |> HtmlAtt.style ]
    [ div [ HtmlAtt.style heading ] [Html.text "Dice roller"]
    , div [ centerContent ++ [("width", "100%")] |> HtmlAtt.style ]
        [ h1 [ item ++ dice |> HtmlAtt.style
             , onClick Roll
             ] [ diceFace |> toString |> Html.text ]
        ]
    ]

gifBox : Bool -> String -> String -> Html Msg
gifBox isFetching topic gifUrl =
  div [ HtmlAtt.style box ]
    [ div [ HtmlAtt.style heading ] [ Html.text topic ]
    , gifOrLoading isFetching gifUrl
    , button [ onClick MorePlease ] [ Html.text "Moar!!!" ]
    ]

gifOrLoading : Bool -> String -> Html Msg
gifOrLoading isFetching gifUrl =
  if isFetching then
    div [] [ Html.text "Loading . . . " ]
  else img [ src gifUrl ] []

clockBox : Float -> Html Msg
clockBox time =
  div [ HtmlAtt.style box ]
    [ div [ HtmlAtt.style heading ] [Html.text "Clock"]
    , clock time
    ]

clock : Float -> Html Msg
clock time =
  let
    angle =
      turns (Time.inMinutes time)

    handX =
      toString (50 + 40 * cos angle)

    handY =
      toString (50 + 40 * sin angle)
  in
    Svg.svg [ viewBox "0 0 100 100", SvgAtt.width "300px" ]
      [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
      , line [ x1 "50", y1 "50", x2 handX, y2 handY, stroke "#023963" ] []
      ]

chatBox : (List String) -> Html Msg
chatBox messages =
  div [ HtmlAtt.style box ]
    [ div [ HtmlAtt.style heading ] [ Html.text "Chat" ]
    , div [] (List.map viewMessage messages)
    , input [ onInput ChatInput ] []
    , button [ onClick Send ] [ Html.text "Send" ]
    ]

viewMessage : String -> Html Msg
viewMessage msg =
  div [] [ Html.text msg ]
