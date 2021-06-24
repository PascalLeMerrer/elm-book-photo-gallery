module Effect exposing (Effect(..), map, none, perform)

import Image exposing (Image)
import List.Extra


type Effect msg
    = UpdateTitle Image String
    | None


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
