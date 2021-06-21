module Pages.Home exposing (..)

import Html exposing (Html, div, img)
import Html.Attributes exposing (class, src)
import Image exposing (Image)


type alias Model =
    { images : List Image }


type Msg
    = NoOp


init : ( Model, Cmd Msg )
init =
    ( { images = Image.defaultList }
    , Cmd.none
    )


view : Model -> Html Msg
view model =
    div [ class "columns is-multiline" ]
        (List.map viewImage model.images)


viewImage : Image -> Html Msg
viewImage image =
    div [ class "column is-one-quarter" ]
        [ img [ src image.small ] [] ]
