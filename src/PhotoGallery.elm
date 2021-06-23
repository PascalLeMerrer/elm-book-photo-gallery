module PhotoGallery exposing (..)

import Browser
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


init : () -> ( Model, Cmd Msg )
init () =
    let
        ( homeModel, homeCmd ) =
            Home.init
    in
    ( { homeModel = homeModel
      , selectionModel = Selection.init Nothing
      , images = Image.defaultList
      }
    , homeCmd |> Cmd.map HomeMsg
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HomeMsg (UserClickedShow image) ->
            ( { model | selectionModel = Selection.init (Just image) }
            , Cmd.none
            )

        HomeMsg homeMsg ->
            let
                ( homeModel, homeCmd ) =
                    Home.update homeMsg model.homeModel
            in
            ( { model | homeModel = homeModel }
            , homeCmd |> Cmd.map HomeMsg
            )

        SelectionMsg selectionMsg ->
            let
                ( selectionModel, selectionCmd ) =
                    Selection.update selectionMsg model.selectionModel
            in
            ( { model | selectionModel = selectionModel }
            , selectionCmd |> Cmd.map SelectionMsg
            )


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
