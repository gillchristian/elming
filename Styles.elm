module Styles exposing (..)

-- STYLES
container : List (String, String)
container =
  [ ("display", "flex")
  , ("justify-content", "space-around")
  , ("flex-wrap", "wrap")
  ]

centerContent : List (String, String)
centerContent =
  [ ("display", "flex")
  , ("justify-content", "center")
  , ("align-items", "center")
  ]

box : List (String, String)
box =
  [ ("border", "1px solid black")
  , ("border-radius", "3px")
  , ("margin", "10px")
  , ("padding", "10px")
  ]

item : List (String, String)
item =
  [ ("margin", "3px")
  ]
