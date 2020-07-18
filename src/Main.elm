module Main exposing (main)

import Board exposing (Board)
import Browser
import Html as H exposing (Html)
import Html.Attributes as A
import Html.Events as E
import Json.Decode as Decode exposing (Decoder)
import Point exposing (..)


type alias Model =
    { board : Board
    , maybeDragging : Maybe Point
    }


type Msg
    = BoardMsg Board.Msg


init : Model
init =
    { board = Board.init
    , maybeDragging = Nothing
    }


main =
    Browser.sandbox { init = init, update = update, view = view }


update : Msg -> Model -> Model
update msg model =
    case msg of
        BoardMsg subMsg ->
            Board.update subMsg model


view : Model -> Html Msg
view model =
    H.main_
        []
        [ Board.view model.board |> H.map BoardMsg ]
