module Point exposing (Point, X(..), Y(..), toList, xList, yList)


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
