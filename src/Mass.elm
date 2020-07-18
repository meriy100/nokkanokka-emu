module Mass exposing (Mass, Stack, first, init, initBlack, initWhite, pop, push, third, view)

import Cube exposing (Color(..), Cube, CubeId(..))
import Html as H exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Json.Decode as Decode exposing (Decoder)
import Point exposing (..)


type Stack
    = Zero
    | One Cube
    | Two Cube Cube
    | Three Cube Cube Cube


type alias Mass =
    { stack : Stack
    }


init : Mass
init =
    { stack = Zero
    }


initBlack : Int -> Mass
initBlack id =
    { stack = One { id = CubeId id, color = Black }
    }


initWhite : Int -> Mass
initWhite id =
    { stack = One { id = CubeId id, color = White }
    }


first : Stack -> Maybe Cube
first stack =
    case stack of
        Zero ->
            Nothing

        One cube ->
            Just cube

        Two cube _ ->
            Just cube

        Three cube _ _ ->
            Just cube


second : Stack -> Maybe Cube
second stack =
    case stack of
        Zero ->
            Nothing

        One _ ->
            Nothing

        Two _ cube ->
            Just cube

        Three _ cube _ ->
            Just cube


third : Stack -> Maybe Cube
third stack =
    case stack of
        Zero ->
            Nothing

        One _ ->
            Nothing

        Two _ _ ->
            Nothing

        Three _ _ cube ->
            Just cube


pop : Stack -> Stack
pop stack =
    case stack of
        Zero ->
            stack

        One _ ->
            Zero

        Two f s ->
            One s

        Three f s t ->
            Two s t


push : Cube -> Stack -> Stack
push cube stack =
    case stack of
        Zero ->
            One cube

        One f ->
            Two cube f

        Two f s ->
            Three cube f s

        Three _ _ _ ->
            stack


view :
    { toDragDecoder : Point -> Decoder msg
    , toDropDecoder : Point -> Decoder ( msg, Bool )
    , none : msg
    }
    -> Point
    -> Mass
    -> Html msg
view msgs point { stack } =
    [ stack |> first |> Maybe.map (Cube.viewFirst (msgs.toDragDecoder point))
    , stack |> second |> Maybe.map Cube.viewSecond
    , stack |> third |> Maybe.map Cube.viewThird
    ]
        |> List.filterMap identity
        |> (H.div [ A.class "cube-wrapper" ] >> List.singleton)
        |> H.div
            [ A.class "mass-container"
            , { x = point.x, y = point.y } |> msgs.toDropDecoder |> E.preventDefaultOn "drop"
            , E.preventDefaultOn "dragenter" (Decode.succeed ( msgs.none, True ))
            , E.preventDefaultOn "dragover" (Decode.succeed ( msgs.none, True ))
            ]
