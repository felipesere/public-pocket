module Main exposing (..)

import Url.Builder as Url
import Json.Decode exposing (field)
import Html exposing (Html, text, div, ol, li)
import Http exposing (send)
import Browser


type alias Page =
    { size : Int, number : Int }


type Msg
    = NewArticles (Result Http.Error ApiResponse)


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


type alias ApiResponse =
    { articles : Articles }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { articles = [] }, initialPage )


initialPage : Cmd Msg
initialPage =
    let
        page =
            { size = 10, number = 0 }
    in
        Http.send NewArticles (Http.get (toPocketUrl page) decodeArticles)


toPocketUrl : Page -> String
toPocketUrl { size, number } =
    Url.crossOrigin "https://publicpocket.herokuapp.com"
        [ "api", "articles", (String.fromInt number), (String.fromInt size) ]
        []


decodeArticles : Json.Decode.Decoder ApiResponse
decodeArticles =
    Json.Decode.map ApiResponse
        (field "articles" <| Json.Decode.list decodeArticle)


decodeArticle : Json.Decode.Decoder Article
decodeArticle =
    Json.Decode.map6 Article
        (field "id" Json.Decode.int)
        (field "title" Json.Decode.string)
        (field "content" Json.Decode.string)
        (field "link" Json.Decode.string)
        (field "time" decodeArticleTime)
        (field "tags" <| Json.Decode.list Json.Decode.string)


decodeArticleTime : Json.Decode.Decoder ArticleTime
decodeArticleTime =
    Json.Decode.map2 ArticleTime
        (field "short" Json.Decode.string)
        (field "long" Json.Decode.string)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewArticles result ->
            case result of
                Err _ ->
                    ( model, Cmd.none )

                Ok apiResponse ->
                    let
                        allArticles =
                            List.append model.articles apiResponse.articles
                    in
                        ( { model | articles = allArticles }, Cmd.none )


view : Model -> Html Msg
view { articles } =
    let
        titles =
            List.map (\article -> li [] [ text article.title ]) articles
    in
        ol [] titles



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }
