module Main exposing (..)

import Url.Builder as Url
import Json.Decode exposing (field)
import Html exposing (Html, text, div, ol, li, button)
import Html.Events exposing (onClick)
import Http exposing (send)
import Browser


type Msg
    = NewArticles (Result Http.Error ApiResponse)
    | LoadMore


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
    , next : String
    }


type alias ApiResponse =
    { articles : Articles
    , next : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    let
        next =
            "/api/articles/0/10"
    in
        ( { articles = [], next = next }, loadPage next )


loadPage : String -> Cmd Msg
loadPage page =
    Http.send NewArticles (Http.get (toPocketUrl page) decodeArticles)


toPocketUrl : String -> String
toPocketUrl page =
    "https://publicpocket.herokuapp.com" ++ page


decodeArticles : Json.Decode.Decoder ApiResponse
decodeArticles =
    Json.Decode.map2 ApiResponse
        (field "articles" <| Json.Decode.list decodeArticle)
        (field "next" <| Json.Decode.string)


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
        LoadMore ->
            ( model, loadPage model.next )

        NewArticles result ->
            case result of
                Err _ ->
                    ( model, Cmd.none )

                Ok apiResponse ->
                    let
                        allArticles =
                            List.append model.articles apiResponse.articles
                    in
                        ( { model | articles = allArticles, next = apiResponse.next }, Cmd.none )


view : Model -> Html Msg
view { articles } =
    let
        titles =
            List.map (\article -> li [] [ text article.title ]) articles
    in
        div []
            [ ol [] titles
            , moreArticles
            ]


moreArticles : Html Msg
moreArticles =
    button [ onClick LoadMore ] [ text "Load More" ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }
