module Route exposing (..)

import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = HomeRoute
    | SelectionRoute Int


{-| Converts a Url to a Route
-}
parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map HomeRoute Parser.top
        , Parser.map SelectionRoute (Parser.s "selection" </> Parser.int)
        ]
