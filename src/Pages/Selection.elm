module Pages.Selection exposing (..)

import Html exposing (Html, a, button, div, img, input, span, text)
import Html.Attributes exposing (class, href, src, value)
import Html.Events exposing (onClick, onInput)
import Image exposing (Image)


type alias Model =
    { image : Maybe Image
    , mode : Mode
    , editedTitle : String
    }


type Msg
    = UserClickedHome
    | UserClickedModify Image
    | UserClickedValidate Image
    | UserChangedTitle String


type Mode
    = ReadOnly
    | Edition


init : Maybe Image -> Model
init maybeImage =
    { image = maybeImage
    , mode = ReadOnly
    , editedTitle = ""
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UserClickedHome ->
            ( { model | image = Nothing }
            , Cmd.none
            )

        UserClickedModify image ->
            ( { model
                | mode = Edition
                , editedTitle = image.title
              }
            , Cmd.none
            )

        UserClickedValidate imageToRename ->
            ( { model
                | mode = ReadOnly
                , image = Just { imageToRename | title = model.editedTitle }
              }
            , Cmd.none
            )

        UserChangedTitle string ->
            ( { model | editedTitle = string }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div []
        [ viewHomeLink model
        , viewImage model
        ]


viewHomeLink : Model -> Html Msg
viewHomeLink model =
    div []
        [ a
            [ href "#"
            , onClick UserClickedHome
            ]
            [ text "Accueil > "
            ]
        , case model.image of
            Just image ->
                viewTitle model image

            Nothing ->
                noContent
        ]


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


viewTitle : Model -> Image -> Html Msg
viewTitle model image =
    span [] <|
        case model.mode of
            ReadOnly ->
                viewReadOnlyTitle image

            Edition ->
                viewEditedTitle model image


viewReadOnlyTitle : Image -> List (Html Msg)
viewReadOnlyTitle image =
    [ span [] [ text image.title ]
    , a
        [ class "is-size-7 pl-3"
        , href "#"
        , onClick (UserClickedModify image)
        ]
        [ text "modifier" ]
    ]


viewEditedTitle : Model -> Image -> List (Html Msg)
viewEditedTitle model image =
    [ input
        [ class "is-size-6"
        , onInput UserChangedTitle
        , value model.editedTitle
        ]
        [ text image.title ]
    , button
        [ class "button is-primary is-small ml-3"
        , onClick (UserClickedValidate image)
        ]
        [ text "Valider" ]
    ]
