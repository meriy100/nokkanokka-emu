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


type Z
    = ZOne
    | ZTwo
    | ZThree


type CubeId
    = CubeId Int


type Cube
    = Cube
        { id : CubeId
        , color : Color
        , x : X
        , y : Y
        , stack :
            { two : Maybe Cube
            , three : Maybe Cube
            }
        }


type alias Model =
    { cubes : List Cube
    , maybeDragOn : Maybe Cube
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


initStack =
    { two = Nothing, three = Nothing }


init : Model
init =
    { cubes =
        List.map (\x -> Cube { id = CubeId 0, color = Black, x = x, y = YOne, stack = initStack }) xList
            ++ List.map (\x -> Cube { id = CubeId 0, color = White, x = x, y = YSix, stack = initStack }) xList
            |> List.indexedMap (\idx -> \(Cube record) -> Cube { record | id = CubeId idx })
    , maybeDragOn = Nothing
    }


main =
    Browser.sandbox { init = init, update = update, view = view }


type Msg
    = DragOn Cube
    | DragOut { x : X, y : Y }
    | None


update : Msg -> Model -> Model
update msg model =
    case msg of
        None ->
            model

        DragOn cube ->
            { model | maybeDragOn = Just cube }

        DragOut point ->
            case model.maybeDragOn of
                Nothing ->
                    { model | maybeDragOn = Nothing }

                Just (Cube cube) ->
                    let
                        newCubes =
                            model.cubes
                                |> List.map
                                    (\(Cube c) ->
                                        if c.x == point.x && c.y == point.y then
                                            Cube
                                                { cube
                                                    | stack = { two = Just (Cube c), three = c.stack.two }
                                                    , x = point.x
                                                    , y = point.y
                                                }

                                        else if c.x == cube.x && c.y == cube.y then
                                            Cube
                                                { cube
                                                    | stack = { two = c.stack.three, three = Nothing }
                                                    , x = point.x
                                                    , y = point.y
                                                }

                                        else
                                            Cube c
                                    )
                    in
                    { model | maybeDragOn = Nothing, cubes = newCubes }


decodeDragStart : Cube -> Decoder Msg
decodeDragStart cube =
    Decode.map (Debug.log "target")
        (Decode.field "target" Decode.value)
        |> Decode.andThen
            (\x ->
                Decode.succeed
                    (DragOn cube)
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


viewCube : Z -> Cube -> Html Msg
viewCube z (Cube cube) =
    let
        colorClass =
            case cube.color of
                Black ->
                    "cube--black"

                White ->
                    "cube--white"

        zLevelClass =
            case z of
                ZOne ->
                    "cube--z-top"

                ZTwo ->
                    "cube--z-two"

                ZThree ->
                    "cube--z-three"

        topEvents =
            if z == ZOne then
                [ cube |> Cube |> decodeDragStart |> E.on "dragstart"
                ]

            else
                []
    in
    H.div
        ([ A.class "cube"
         , A.class colorClass
         , A.class zLevelClass
         , A.attribute "draggable" "true"
         ]
            ++ topEvents
        )
        []


viewMass : { x : X, y : Y, cubes : List Cube } -> Html Msg
viewMass { x, y, cubes } =
    let
        maybeCurrentCube =
            cubes
                |> List.filter (\(Cube c) -> c.x == x && c.y == y)
                |> List.head

        maybeCurrentCubeView =
            maybeCurrentCube
                |> Maybe.map (viewCube ZOne)

        maybeSecondCube =
            maybeCurrentCube
                |> Maybe.andThen (\(Cube c) -> c.stack.two)
                |> Maybe.map (viewCube ZTwo)

        maybeThirdCube =
            maybeCurrentCube
                |> Maybe.andThen (\(Cube c) -> c.stack.three)
                |> Maybe.map (viewCube ZThree)
    in
    [ maybeCurrentCubeView, maybeSecondCube, maybeThirdCube ]
        |> List.filterMap identity
        |> (H.div [ A.class "cube-wrapper" ] >> List.singleton)
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
