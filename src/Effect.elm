module Effect exposing (Effect(..), map, none, perform)

import Http
import Image exposing (Image, imageListDecoder)
import List.Extra


type Effect msg
    = UpdateTitle Image String
    | None
    | LoadImages (Result Http.Error (List Image) -> msg)
    | UpdateImages (List Image)


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


none =
    None


updateImage : Image -> String -> Model a -> Model a
updateImage image title model =
    let
        images =
            List.Extra.updateIf
                (\item -> item == image)
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
