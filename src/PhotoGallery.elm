module PhotoGallery exposing (..)

import Browser
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
type alias Model = {}

type Msg = NoOp

init : () -> ( Model, Cmd Msg )
init () =
    ({}, Cmd.none)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    (model, Cmd.none)

main : Program () Model Msg
main =
    Browser.document
    { init = init
    , update = update
    , view = view
    , subscriptions = \_ -> Sub.none
    }


view : Model -> Browser.Document Msg -- 1
view model =
    { title = "Photo Gallery"
    , body = [ viewBody model]
    }
viewBody : Model -> Html Msg
viewBody model =
    div [ class "container" ]
        [ viewTitle ]

viewTitle : Html Msg
viewTitle =
    h1 [ class "title is-1" ]
        [ text "Photo Gallery" ]


