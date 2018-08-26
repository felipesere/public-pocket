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


init : () -> ( Model, Cmd Msg )
init _ =
    ( { articles = [] }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    text "Hello World!"



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }
