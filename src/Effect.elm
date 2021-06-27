module Effect exposing (Effect(..), map, none, perform)

import Browser exposing (UrlRequest(..))
import Browser.Navigation as Nav
import Http
import Image exposing (Image, imageListDecoder)
import List.Extra
import Url


type Effect msg
    = UpdateTitle Image String
    | None
    | LoadImages (Result Http.Error (List Image) -> msg)
    | UpdateImages (List Image)
    | GoToUrl Nav.Key UrlRequest


type alias Model a =
    { a | images : List Image }


perform : ( Model a, Effect msg ) -> ( Model a, Cmd msg )
perform ( model, effect ) =
    case effect of
        UpdateTitle image title ->
            ( updateImage image title model
            , Cmd.none
            )

        None ->
            ( model, Cmd.none )

        LoadImages msg ->
            ( model
            , Http.get
                { url = "http://localhost:7000/search/monde"
                , expect = Http.expectJson msg imageListDecoder
                }
            )

        UpdateImages images ->
            ( { model | images = images }
            , Cmd.none
            )

        GoToUrl key urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl key (Url.toString url)
                    )

                External url ->
                    ( model
                    , Nav.load url
                    )


none =
    None


updateImage : Image -> String -> Model a -> Model a
updateImage image title model =
    let
        images =
            List.Extra.updateIf
                (\item -> item.small == image.small)
                (\_ -> { image | title = title })
                model.images
    in
    { model | images = images }


map : (a -> msg) -> Effect a -> Effect msg
map parentMsgConstructor effect =
    case effect of
        UpdateTitle image string ->
            UpdateTitle image string

        None ->
            None

        LoadImages msg ->
            LoadImages (msg >> parentMsgConstructor)

        UpdateImages images ->
            UpdateImages images

        GoToUrl key urlRequest ->
            GoToUrl key urlRequest
