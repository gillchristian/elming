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
  ]

column : List (String, String)
column =
  [ ("display", "flex")
  , ("flex-direction", "column")
  ]

item : List (String, String)
item =
  [ ("margin", "3px")
  ]

heading : List (String, String)
heading =
  [ ("width", "100%")
  , ("padding", "10px")
  , ("border-bottom", "1px solid black")
  ]

dice : List (String, String)
dice =
  [ ("cursor", "pointer")
  , ("font-family", "Helvetica")
  ]
