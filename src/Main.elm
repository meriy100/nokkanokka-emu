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


type alias Cube =
    { id : CubeId
    , color : Color
    , x : X
    , y : Y
    , z : Z
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


zList : List Z
zList =
    [ ZOne
    , ZTwo
    , ZThree
    ]


init : Model
init =
    { cubes =
        List.map (\x -> { id = CubeId 0, color = Black, x = x, y = YOne, z = ZOne }) xList
            ++ List.map (\x -> { id = CubeId 0, color = White, x = x, y = YSix, z = ZOne }) xList
            |> List.indexedMap (\idx -> \cube -> { cube | id = CubeId idx })
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

                Just cube ->
                    let
                        movedCube =
                            { cube | x = point.x, y = point.y, z = ZOne }

                        newCubes =
                            model.cubes
                                |> List.map
                                    (\c ->
                                        if c.id == movedCube.id then
                                            movedCube

                                        else if c.x == point.x && c.y == point.y then
                                            case c.z of
                                                ZOne ->
                                                    { c | z = ZTwo }

                                                ZTwo ->
                                                    { c | z = ZThree }

                                                ZThree ->
                                                    c

                                        else if c.x == cube.x && c.y == cube.y then
                                            case c.z of
                                                ZOne ->
                                                    c

                                                ZTwo ->
                                                    { c | z = ZOne }

                                                ZThree ->
                                                    { c | z = ZTwo }

                                        else
                                            c
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


viewCube : Cube -> Html Msg
viewCube cube =
    let
        colorClass =
            case cube.color of
                Black ->
                    "cube--black"

                White ->
                    "cube--white"

        zLevelClass =
            case cube.z of
                ZOne ->
                    "cube--z-top"

                ZTwo ->
                    "cube--z-two"

                ZThree ->
                    "cube--z-three"

        topEvents =
            if cube.z == ZOne then
                [ cube |> decodeDragStart |> E.on "dragstart"
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
        currentCubes =
            cubes |> List.filter (\c -> c.x == x && c.y == y)
    in
    currentCubes
        |> List.map viewCube
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
