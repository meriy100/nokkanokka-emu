module Main exposing (main)

import Browser
import Html as H exposing (Html)
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


viewMass =
    H.div []
        []


view model =
    H.div []
        (yList
            |> List.map
                (\y ->
                    xList |> List.map (\x -> viewMass)
                )
            |> List.concat
        )
