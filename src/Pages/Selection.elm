module Pages.Selection exposing (..)

import Html exposing (Html, a, div, img, text)
import Html.Attributes exposing (href, src)
import Html.Events exposing (onClick)
import Image exposing (Image)


type alias Model =
    { image : Maybe Image
    }


type Msg
    = UserClickedHome


init : Maybe Image -> Model
init maybeImage =
    { image = maybeImage }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UserClickedHome ->
            ( { image = Nothing }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div []
        [ viewHomeLink
        , viewImage model
        ]


viewHomeLink : Html Msg
viewHomeLink =
    a
        [ href "#"
        , onClick UserClickedHome
        ]
        [ text "Accueil > " ]


viewImage : Model -> Html Msg
viewImage model =
    case model.image of
        Just image ->
            img [ src image.large ] []

        Nothing ->
            noContent


noContent : Html msg
noContent =
    text ""
