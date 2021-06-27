module PhotoGallery exposing (..)

import Browser
import Effect exposing (Effect)
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Image exposing (Image)
import Pages.Home as Home exposing (Msg(..))
import Pages.Selection as Selection


type alias Model =
    { homeModel : Home.Model
    , selectionModel : Selection.Model
    , images : List Image
    }


type Msg
    = HomeMsg Home.Msg
    | SelectionMsg Selection.Msg


init : () -> ( Model, Effect Msg )
init () =
    let
        ( homeModel, homeEffect ) =
            Home.init
    in
    ( { homeModel = homeModel
      , selectionModel = Selection.init Nothing
      , images = Image.defaultList
      }
    , homeEffect |> Effect.map HomeMsg
    )


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        HomeMsg (UserClickedShow image) ->
            ( { model | selectionModel = Selection.init (Just image) }
            , Effect.none
            )

        HomeMsg homeMsg ->
            let
                ( homeModel, effectCmd ) =
                    Home.update homeMsg model.homeModel
            in
            ( { model | homeModel = homeModel }
            , effectCmd |> Effect.map HomeMsg
            )

        SelectionMsg selectionMsg ->
            let
                ( selectionModel, effectCmd ) =
                    Selection.update selectionMsg model.selectionModel
            in
            ( { model | selectionModel = selectionModel }
            , effectCmd |> Effect.map SelectionMsg
            )


main : Program () Model Msg
main =
    Browser.document
        { init = init >> Effect.perform
        , update = \msg model -> update msg model |> Effect.perform
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
        , case model.selectionModel.image of
            Just _ ->
                viewSelection model

            Nothing ->
                viewHome model
        ]


viewTitle : Html Msg
viewTitle =
    h1 [ class "title is-1" ]
        [ text "Photo Gallery" ]


viewHome : Model -> Html Msg
viewHome model =
    Home.view model.homeModel model.images
        |> Html.map HomeMsg


viewSelection : Model -> Html Msg
viewSelection model =
    Selection.view model.selectionModel
        |> Html.map SelectionMsg
