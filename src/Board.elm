module Board exposing (Board, Msg, init, update, view)

import Cube exposing (Cube)
import Html as H exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Json.Decode as Decode exposing (Decoder)
import Mass exposing (Mass, Stack)
import Point exposing (..)


type alias Board =
    { m11 : Mass
    , m12 : Mass
    , m13 : Mass
    , m14 : Mass
    , m15 : Mass
    , m16 : Mass
    , m21 : Mass
    , m22 : Mass
    , m23 : Mass
    , m24 : Mass
    , m25 : Mass
    , m26 : Mass
    , m31 : Mass
    , m32 : Mass
    , m33 : Mass
    , m34 : Mass
    , m35 : Mass
    , m36 : Mass
    , m41 : Mass
    , m42 : Mass
    , m43 : Mass
    , m44 : Mass
    , m45 : Mass
    , m46 : Mass
    , m51 : Mass
    , m52 : Mass
    , m53 : Mass
    , m54 : Mass
    , m55 : Mass
    , m56 : Mass
    }


type Msg
    = DragStart Point
    | Drop Point
    | None


init : Board
init =
    { m11 = Mass.initBlack 1
    , m21 = Mass.initBlack 2
    , m31 = Mass.initBlack 3
    , m41 = Mass.initBlack 4
    , m51 = Mass.initBlack 5
    , m12 = Mass.init
    , m22 = Mass.init
    , m32 = Mass.init
    , m42 = Mass.init
    , m52 = Mass.init
    , m13 = Mass.init
    , m23 = Mass.init
    , m33 = Mass.init
    , m43 = Mass.init
    , m53 = Mass.init
    , m14 = Mass.init
    , m24 = Mass.init
    , m34 = Mass.init
    , m44 = Mass.init
    , m54 = Mass.init
    , m15 = Mass.init
    , m25 = Mass.init
    , m35 = Mass.init
    , m45 = Mass.init
    , m55 = Mass.init
    , m16 = Mass.initWhite 6
    , m26 = Mass.initWhite 7
    , m36 = Mass.initWhite 8
    , m46 = Mass.initWhite 9
    , m56 = Mass.initWhite 10
    }


setMass : Point -> Stack -> Board -> Board
setMass point stack board =
    case ( point.x, point.y ) of
        ( XOne, YOne ) ->
            { board | m11 = { stack = stack } }

        ( XOne, YTwo ) ->
            { board | m12 = { stack = stack } }

        ( XOne, YThree ) ->
            { board | m13 = { stack = stack } }

        ( XOne, YFour ) ->
            { board | m14 = { stack = stack } }

        ( XOne, YFive ) ->
            { board | m15 = { stack = stack } }

        ( XOne, YSix ) ->
            { board | m16 = { stack = stack } }

        ( XTwo, YOne ) ->
            { board | m21 = { stack = stack } }

        ( XTwo, YTwo ) ->
            { board | m22 = { stack = stack } }

        ( XTwo, YThree ) ->
            { board | m23 = { stack = stack } }

        ( XTwo, YFour ) ->
            { board | m24 = { stack = stack } }

        ( XTwo, YFive ) ->
            { board | m25 = { stack = stack } }

        ( XTwo, YSix ) ->
            { board | m26 = { stack = stack } }

        ( XThree, YOne ) ->
            { board | m31 = { stack = stack } }

        ( XThree, YTwo ) ->
            { board | m32 = { stack = stack } }

        ( XThree, YThree ) ->
            { board | m33 = { stack = stack } }

        ( XThree, YFour ) ->
            { board | m34 = { stack = stack } }

        ( XThree, YFive ) ->
            { board | m35 = { stack = stack } }

        ( XThree, YSix ) ->
            { board | m36 = { stack = stack } }

        ( XFour, YOne ) ->
            { board | m41 = { stack = stack } }

        ( XFour, YTwo ) ->
            { board | m42 = { stack = stack } }

        ( XFour, YThree ) ->
            { board | m43 = { stack = stack } }

        ( XFour, YFour ) ->
            { board | m44 = { stack = stack } }

        ( XFour, YFive ) ->
            { board | m45 = { stack = stack } }

        ( XFour, YSix ) ->
            { board | m46 = { stack = stack } }

        ( XFive, YOne ) ->
            { board | m51 = { stack = stack } }

        ( XFive, YTwo ) ->
            { board | m52 = { stack = stack } }

        ( XFive, YThree ) ->
            { board | m53 = { stack = stack } }

        ( XFive, YFour ) ->
            { board | m54 = { stack = stack } }

        ( XFive, YFive ) ->
            { board | m55 = { stack = stack } }

        ( XFive, YSix ) ->
            { board | m56 = { stack = stack } }


findMass : Board -> Point -> Mass
findMass board point =
    case ( point.x, point.y ) of
        ( XOne, YOne ) ->
            board.m11

        ( XOne, YTwo ) ->
            board.m12

        ( XOne, YThree ) ->
            board.m13

        ( XOne, YFour ) ->
            board.m14

        ( XOne, YFive ) ->
            board.m15

        ( XOne, YSix ) ->
            board.m16

        ( XTwo, YOne ) ->
            board.m21

        ( XTwo, YTwo ) ->
            board.m22

        ( XTwo, YThree ) ->
            board.m23

        ( XTwo, YFour ) ->
            board.m24

        ( XTwo, YFive ) ->
            board.m25

        ( XTwo, YSix ) ->
            board.m26

        ( XThree, YOne ) ->
            board.m31

        ( XThree, YTwo ) ->
            board.m32

        ( XThree, YThree ) ->
            board.m33

        ( XThree, YFour ) ->
            board.m34

        ( XThree, YFive ) ->
            board.m35

        ( XThree, YSix ) ->
            board.m36

        ( XFour, YOne ) ->
            board.m41

        ( XFour, YTwo ) ->
            board.m42

        ( XFour, YThree ) ->
            board.m43

        ( XFour, YFour ) ->
            board.m44

        ( XFour, YFive ) ->
            board.m45

        ( XFour, YSix ) ->
            board.m46

        ( XFive, YOne ) ->
            board.m51

        ( XFive, YTwo ) ->
            board.m52

        ( XFive, YThree ) ->
            board.m53

        ( XFive, YFour ) ->
            board.m54

        ( XFive, YFive ) ->
            board.m55

        ( XFive, YSix ) ->
            board.m56


map : (Point -> Mass -> a) -> Board -> List a
map f board =
    Point.toList
        |> List.map (\p -> ( p, findMass board p ))
        |> List.map (\( p, mass ) -> f p mass)


update : Msg -> { board : Board, maybeDragging : Maybe Point } -> { board : Board, maybeDragging : Maybe Point }
update msg ({ board, maybeDragging } as model) =
    case msg of
        DragStart point ->
            { model | maybeDragging = Just point }

        Drop point ->
            case maybeDragging of
                Nothing ->
                    model

                Just draggingPoint ->
                    if draggingPoint |> Point.eq point then
                        { model | maybeDragging = Nothing }

                    else
                        let
                            from =
                                findMass board draggingPoint

                            to =
                                findMass board point
                        in
                        case ( from.stack |> Mass.first, to.stack |> Mass.third ) of
                            ( Just target, Nothing ) ->
                                { board = setMass draggingPoint (from.stack |> Mass.pop) board |> setMass point (to.stack |> Mass.push target)
                                , maybeDragging = Nothing
                                }

                            _ ->
                                { model | maybeDragging = Nothing }

        None ->
            model


view : Board -> Html Msg
view board =
    H.div
        [ A.class "board-container"
        ]
        (board
            |> map
                (Mass.view
                    { toDragDecoder = decodeDragStart
                    , toDropDecoder = decodeDrop
                    , none = None
                    }
                )
        )


decodeDragStart : Point -> Decoder Msg
decodeDragStart point =
    Decode.map (Debug.log "target")
        (Decode.field "target" Decode.value)
        |> Decode.andThen
            (\x ->
                Decode.succeed
                    (DragStart point)
            )


decodeDrop : Point -> Decoder ( Msg, Bool )
decodeDrop point =
    Decode.map (Debug.log "target")
        (Decode.field "target" Decode.value)
        |> Decode.andThen
            (\x ->
                Decode.succeed
                    ( Drop point, True )
            )
