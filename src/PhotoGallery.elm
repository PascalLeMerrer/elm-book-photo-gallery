module PhotoGallery exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Effect exposing (Effect)
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Image exposing (Image)
import Pages.Home as Home exposing (Msg(..))
import Pages.Selection as Selection
import Url exposing (Url)


type alias Model =
    { images : List Image
    , page : Page
    , navigationKey : Key
    }


type Msg
    = HomeMsg Home.Msg
    | SelectionMsg Selection.Msg
    | UrlChanged Url
    | UserClickedLink UrlRequest


type Page
    = HomePage Home.Model
    | SelectionPage Selection.Model
    | PageNotFound


init : Url -> Key -> ( Model, Effect Msg )
init url navigationKey =
    let
        _ =
            Debug.log "url initiale" url

        ( homeModel, homeEffect ) =
            Home.init
    in
    ( { images = []
      , page = HomePage homeModel
      , navigationKey = navigationKey
      }
    , homeEffect |> Effect.map HomeMsg
    )


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case ( msg, model.page ) of
        ( HomeMsg (UserClickedShow image), HomePage _ ) ->
            ( { model | page = SelectionPage <| Selection.init (Just image) }
            , Effect.none
            )

        ( HomeMsg homeMsg, HomePage homeModel ) ->
            let
                ( updatedHomeModel, effectCmd ) =
                    Home.update homeMsg homeModel
            in
            ( { model | page = HomePage updatedHomeModel }
            , effectCmd |> Effect.map HomeMsg
            )

        ( SelectionMsg selectionMsg, SelectionPage selectionModel ) ->
            let
                ( updatedSelectionModel, effectCmd ) =
                    Selection.update selectionMsg selectionModel
            in
            ( { model | page = SelectionPage updatedSelectionModel }
            , effectCmd |> Effect.map SelectionMsg
            )

        ( UrlChanged url, _ ) ->
            ( model, Effect.None )

        ( UserClickedLink urlRequest, _ ) ->
            let
                _ =
                    Debug.log "UserClickedLink" urlRequest
            in
            ( model, Effect.GoToUrl model.navigationKey urlRequest )

        _ ->
            ( model, Effect.None )


main : Program () Model Msg
main =
    Browser.application
        { init = \() url key -> init url key |> Effect.perform
        , onUrlChange = \url -> UrlChanged url
        , onUrlRequest = \urlRequest -> UserClickedLink urlRequest
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
        , case model.page of
            SelectionPage selectionModel ->
                viewSelection selectionModel

            HomePage homeModel ->
                viewHome model homeModel

            PageNotFound ->
                viewPageNotFound
        ]


viewPageNotFound : Html Msg
viewPageNotFound =
    div [] [ text "Page non trouvée." ]


viewTitle : Html Msg
viewTitle =
    h1 [ class "title is-1" ]
        [ text "Photo Gallery" ]


viewHome : Model -> Home.Model -> Html Msg
viewHome model homeModel =
    Home.view homeModel model.images
        |> Html.map HomeMsg


viewSelection : Selection.Model -> Html Msg
viewSelection selectionModel =
    Selection.view selectionModel
        |> Html.map SelectionMsg
