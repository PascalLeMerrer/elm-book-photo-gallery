module Image exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline exposing (hardcoded, required)


type alias Image =
    { large : String
    , small : String
    , title : String
    }


imageDecoder : Decode.Decoder Image
imageDecoder =
    Decode.succeed Image
        |> required "thumbnail" imageUrlDecoder
        |> required "large" imageUrlDecoder
        |> hardcoded ""


imageUrlDecoder : Decode.Decoder String
imageUrlDecoder =
    Decode.string |> Decode.andThen addUrlBase


addUrlBase : String -> Decode.Decoder String
addUrlBase path =
    Decode.succeed ("http://localhost:7000" ++ path)


imageListDecoder : Decode.Decoder (List Image)
imageListDecoder =
    Decode.field "results" (Decode.list imageDecoder)


defaultList : List Image
defaultList =
    [ { small = "http://localhost:7000/images/LON1_small.jpeg"
      , large = "http://localhost:7000/images/LON1_large.jpeg"
      , title = "Londres 1"
      }
    , { small = "http://localhost:7000/images/LON2_small.jpeg"
      , large = "http://localhost:7000/images/LON2_large.jpeg"
      , title = "Londres 2"
      }
    , { small = "http://localhost:7000/images/LON3_small.jpeg"
      , large = "http://localhost:7000/images/LON3_large.jpeg"
      , title = "Londres 3"
      }
    ]
