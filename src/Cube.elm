module Cube exposing (Color(..), Cube, CubeId(..), viewFirst, viewSecond, viewThird)

import Html as H exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Json.Decode exposing (Decoder)


type CubeId
    = CubeId Int


type alias Cube =
    { id : CubeId
    , color : Color
    }


type Color
    = Black
    | White


colorClass cube =
    case cube.color of
        Black ->
            A.class "cube--black"

        White ->
            A.class "cube--white"


viewThird cube =
    H.div
        [ A.class "cube"
        , colorClass cube
        , A.class "cube--z-third"
        ]
        []


viewSecond cube =
    H.div
        [ A.class "cube"
        , colorClass cube
        , A.class "cube--z-second"
        ]
        []


viewFirst : Decoder msg -> Cube -> Html msg
viewFirst decoder cube =
    H.div
        [ A.class "cube"
        , colorClass cube
        , A.class "cube--z-first"
        , A.attribute "draggable" "true"
        , decoder |> E.on "dragstart"
        ]
        []
