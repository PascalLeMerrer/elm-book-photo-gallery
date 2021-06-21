module Pages.Selection exposing (..)

import Html exposing (Html, img, text)
import Html.Attributes exposing (src)
import Image exposing (Image)


type alias Model =
    { image : Maybe Image
    }


type Msg
    = NoOp


init : Maybe Image -> Model
init maybeImage =
    { image = maybeImage }


view : Model -> Html Msg
view model =
    case model.image of
        Just image ->
            img [ src image.large ] []

        Nothing ->
            noContent


noContent : Html msg
noContent =
    text ""
