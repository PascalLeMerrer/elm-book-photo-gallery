module PhotoGallery exposing (..)

import Browser
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Pages.Home as Home


type alias Model =
    { homeModel : Home.Model
    }


type Msg
    = HomeMsg Home.Msg


init : () -> ( Model, Cmd Msg )
init () =
    let
        ( homeModel, homeCmd ) =
            Home.init
    in
    ( { homeModel = homeModel
      }
    , homeCmd |> Cmd.map HomeMsg
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


view :
    Model
    -> Browser.Document Msg -- 1
view model =
    { title = "Photo Gallery"
    , body = [ viewBody model ]
    }


viewBody : Model -> Html Msg
viewBody model =
    div [ class "container" ]
        [ viewTitle
        , Home.view model.homeModel
            |> Html.map HomeMsg
        ]


viewTitle : Html Msg
viewTitle =
    h1 [ class "title is-1" ]
        [ text "Photo Gallery" ]
