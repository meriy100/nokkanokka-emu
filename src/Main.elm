module Main exposing (main)

import Browser
import Html as H exposing (Html)
import Html.Attributes as A
import Html.Events exposing (onClick)


type Color
    = Black
    | White


type X
    = XOne
    | XTwo
    | XThree
    | XFour
    | XFive


type Y
    = YOne
    | YTwo
    | YThree
    | YFour
    | YFive
    | YSix


type alias Cube =
    { color : Color
    , x : X
    , y : Y
    }


type alias Model =
    { cubes : List Cube
    }


xList : List X
xList =
    [ XOne
    , XTwo
    , XThree
    , XFour
    , XFive
    ]


yList : List Y
yList =
    [ YOne
    , YTwo
    , YThree
    , YFour
    , YFive
    , YSix
    ]


init : Model
init =
    { cubes =
        List.map (\x -> { color = Black, x = x, y = YOne }) xList
            ++ List.map (\x -> { color = White, x = x, y = YSix }) xList
    }


main =
    Browser.sandbox { init = init, update = update, view = view }


type Msg
    = Increment
    | Decrement


update msg model =
    case msg of
        Increment ->
            model

        Decrement ->
            model


viewCube : Cube -> Html Msg
viewCube cube =
    let
        colorClass =
            case cube.color of
                Black ->
                    "cube__black"

                White ->
                    "cube__white"
    in
    H.div [ A.class "cube", A.class colorClass ]
        []


viewMass : { x : X, y : Y, cubes : List Cube } -> Html Msg
viewMass { x, y, cubes } =
    let
        maybeCurrentCube =
            cubes |> List.filter (\c -> c.x == x && c.y == y) |> List.head
    in
    maybeCurrentCube
        |> Maybe.andThen (viewCube >> List.singleton >> Just)
        |> Maybe.withDefault []
        |> H.div
            [ A.class "mass-container" ]


view model =
    H.div
        [ A.class "board-container"
        ]
        (yList
            |> List.map
                (\y ->
                    xList |> List.map (\x -> viewMass { x = x, y = y, cubes = model.cubes })
                )
            |> List.concat
        )
