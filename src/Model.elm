module Model exposing (Model, model)

import Time exposing (Time)

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
