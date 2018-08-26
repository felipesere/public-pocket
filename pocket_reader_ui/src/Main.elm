module Main exposing (..)

import Html exposing (Html, text)
import Browser


type Msg
    = NoOp


type alias Article =
    { id : Int
    , title : String
    , content : String
    , link : String
    , time : ArticleTime
    , tags : List String
    }


type alias ArticleTime =
    { short : String
    , long : String
    }


type alias Articles =
    List Article


type alias Model =
    { articles : Articles
    }


init : Model
init =
    { articles = [] }


update : Msg -> Model -> Model
update msg model =
    model


view : Model -> Html Msg
view model =
    text "Hello World!"


main =
    Browser.sandbox { init = init, update = update, view = view }
