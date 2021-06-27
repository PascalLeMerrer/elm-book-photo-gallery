module Image exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline exposing (hardcoded, required)


type alias Image =
    { id : Int
    , small : String
    , large : String
    , title : String
    }


imageDecoder : Decode.Decoder Image
imageDecoder =
    Decode.succeed Image
        |> hardcoded 0
        |> required "thumbnail" imageUrlDecoder
        |> required "large" imageUrlDecoder
        |> hardcoded ""


imageUrlDecoder : Decode.Decoder String
imageUrlDecoder =
    Decode.string
        |> Decode.andThen addUrlBase


addUrlBase : String -> Decode.Decoder String
addUrlBase path =
    Decode.succeed ("http://localhost:7000" ++ path)


imageListDecoder : Decode.Decoder (List Image)
imageListDecoder =
    Decode.field "results" (Decode.list imageDecoder)
        |> Decode.andThen addIdentifiers


addIdentifiers : List Image -> Decode.Decoder (List Image)
addIdentifiers images =
    Decode.succeed (List.indexedMap addImageId images)


addImageId : Int -> Image -> Image
addImageId index image =
    { image | id = index + 1 }
