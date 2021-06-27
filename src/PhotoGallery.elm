module PhotoGallery exposing (..)

import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Effect exposing (Effect)
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Http
import Image exposing (Image)
import List.Extra
import Pages.Home as Home exposing (Msg(..))
import Pages.Selection as Selection
import Route exposing (Route(..))
import Url exposing (Url)
import Url.Parser as Parser


type alias Model =
    { images : List Image
    , page : Page
    , navigationKey : Key
    , initialUrl : Url
    }


type Msg
    = HomeMsg Home.Msg
    | SelectionMsg Selection.Msg
    | UrlChanged Url
    | UserClickedLink UrlRequest
    | ServerReturnedImages (Result Http.Error (List Image))


type Page
    = HomePage Home.Model
    | SelectionPage Selection.Model
    | PageNotFound


init : Url -> Key -> ( Model, Effect Msg )
init url navigationKey =
    let
        _ =
            Debug.log "url initiale" url

        homeModel =
            Home.init
    in
    ( { images = []
      , page = PageNotFound
      , navigationKey = navigationKey
      , initialUrl = url
      }
    , Effect.LoadImages ServerReturnedImages
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
            gotoPage url model

        ( UserClickedLink urlRequest, _ ) ->
            let
                _ =
                    Debug.log "UserClickedLink" urlRequest
            in
            ( model, Effect.GoToUrl model.navigationKey urlRequest )

        ( ServerReturnedImages (Ok images), PageNotFound ) ->
            gotoPage model.initialUrl { model | images = images }

        ( ServerReturnedImages (Err error), PageNotFound ) ->
            ( model
            , Effect.None
            )

        _ ->
            ( model, Effect.None )


{-| Changes the current page according to the provided route
-}
gotoPage : Url -> Model -> ( Model, Effect Msg )
gotoPage url model =
    case Parser.parse Route.parser url of
        Just (SelectionRoute imageId) ->
            let
                selectedImage =
                    List.Extra.find (\image -> image.id == imageId) model.images

                selectionModel =
                    Selection.init selectedImage
            in
            ( { model
                | page = SelectionPage selectionModel
              }
            , Effect.none
            )

        Just HomeRoute ->
            let
                homeModel =
                    Home.init
            in
            ( { model | page = HomePage homeModel }
            , Effect.none
            )

        Nothing ->
            ( { model
                | page = PageNotFound
              }
            , Effect.none
            )


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
