module Pages.Home exposing (..)

import Html exposing (Html, a, button, div, footer, img, p, text)
import Html.Attributes exposing (class, href, src)
import Html.Events exposing (onClick)
import Image exposing (Image)


type alias Model =
    { images : List Image
    , highlightedImage : Maybe Image
    }


type Msg
    = UserClickedImage Image
    | UserClickedClose
    | UserClickedShow Image


init : ( Model, Cmd Msg )
init =
    ( { images = Image.defaultList
      , highlightedImage = Nothing
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UserClickedImage image ->
            ( { model | highlightedImage = Just image }
            , Cmd.none
            )

        UserClickedClose ->
            ( { model | highlightedImage = Nothing }
            , Cmd.none
            )

        UserClickedShow image ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ viewHighlightedImage model
        , viewImages model
        ]


viewImages : Model -> Html Msg
viewImages model =
    div [ class "columns is-multiline" ]
        (List.map viewImage model.images)


viewHighlightedImage : Model -> Html Msg
viewHighlightedImage model =
    case model.highlightedImage of
        Just image ->
            div [ class "modal is-active" ]
                [ viewModalBackground
                , viewModalContent image
                , viewCloseButton
                ]

        Nothing ->
            text ""


viewModalBackground : Html msg
viewModalBackground =
    div [ class "modal-background" ] []


viewModalContent : Image -> Html Msg
viewModalContent image =
    div [ class "modal-content" ]
        [ img
            [ src image.large ]
            []
        ]


viewCloseButton : Html Msg
viewCloseButton =
    button
        [ class "modal-close is-large"
        , onClick UserClickedClose
        ]
        []


viewImage : Image -> Html Msg
viewImage image =
    div [ class "column is-one-quarter" ]
        [ div [ class "card" ]
            [ div [ class "card-content" ]
                [ div [ class "card-content" ]
                    [ p [ class "image is-4by3" ]
                        [ img
                            [ src image.small
                            , onClick (UserClickedImage image)
                            ]
                            []
                        ]
                    ]
                ]
            , footer [ class "card-footer" ]
                [ a
                    [ class "card-footer-item"
                    , href "#"
                    , onClick <| UserClickedShow image
                    ]
                    [ text "Voir" ]
                ]
            ]
        ]
