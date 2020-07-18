module Main exposing (main)

import Browser
import Html as H exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Json.Decode as Decode exposing (Decoder)


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


type CubeId
    = CubeId Int


type alias Cube =
    { id : CubeId
    , color : Color
    , x : X
    , y : Y
    }


type alias Model =
    { cubes : List Cube
    , maybeDragOn : Maybe CubeId
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
        List.map (\x -> { id = CubeId 0, color = Black, x = x, y = YOne }) xList
            ++ List.map (\x -> { id = CubeId 0, color = White, x = x, y = YSix }) xList
            |> List.indexedMap (\idx -> \cube -> { cube | id = CubeId idx })
    , maybeDragOn = Nothing
    }


main =
    Browser.sandbox { init = init, update = update, view = view }


type Msg
    = DragOn CubeId
    | DragOut { x : X, y : Y }
    | None


update : Msg -> Model -> Model
update msg model =
    case msg of
        None ->
            model

        DragOn cubeId ->
            { model | maybeDragOn = Just cubeId }

        DragOut point ->
            let
                maybeTargetCube =
                    model.maybeDragOn
                        |> Maybe.andThen
                            (\cubeId ->
                                model.cubes |> List.filter (\c -> c.id == cubeId) |> List.head
                            )

                newCubes =
                    case maybeTargetCube of
                        Nothing ->
                            model.cubes

                        Just targetCube ->
                            model.cubes
                                |> List.map
                                    (\c ->
                                        if c.id == targetCube.id then
                                            { c | x = point.x, y = point.y }

                                        else
                                            c
                                    )
            in
            { model | maybeDragOn = Nothing, cubes = newCubes }


decodeDragStart : CubeId -> Decoder Msg
decodeDragStart cubeId =
    Decode.map (Debug.log "target")
        (Decode.field "target" Decode.value)
        |> Decode.andThen
            (\x ->
                Decode.succeed
                    (DragOn cubeId)
            )


decodeDrop : { x : X, y : Y } -> Decoder ( Msg, Bool )
decodeDrop point =
    Decode.map (Debug.log "target")
        (Decode.field "target" Decode.value)
        |> Decode.andThen
            (\x ->
                Decode.succeed
                    ( DragOut point, True )
            )


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
    H.div
        [ A.class "cube"
        , A.class colorClass
        , A.attribute "draggable" "true"
        , cube.id |> decodeDragStart |> E.on "dragstart"
        ]
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
            [ A.class "mass-container"
            , { x = x, y = y } |> decodeDrop |> E.preventDefaultOn "drop"
            , E.preventDefaultOn "dragenter" (Decode.succeed ( None, True ))
            , E.preventDefaultOn "dragover" (Decode.succeed ( None, True ))
            ]


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
