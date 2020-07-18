module Point exposing (Point, X(..), Y(..), eq, toList, xList, yList)


type alias Point =
    { x : X, y : Y }


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


toList : List Point
toList =
    yList
        |> List.map
            (\y ->
                xList |> List.map (\x -> { x = x, y = y })
            )
        |> List.concat


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


eq : Point -> Point -> Bool
eq point1 point2 =
    point1.x == point2.x && point1.y == point2.y
