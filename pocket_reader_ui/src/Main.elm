module Main exposing (..)

import Url.Builder as Url
import Json.Decode exposing (field, maybe)
import Html exposing (Html, text, div, ol, li, button)
import Html.Events exposing (onClick)
import Http exposing (send)
import Browser
import Debug exposing (..)


type Msg
    = NewArticles (Result Http.Error ApiResponse)
    | Load String


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


type Page
    = Next String
    | NextPrevious String String
    | Previous String


derive { previous, next } =
    case ( previous, next ) of
        ( Just m, Just n ) ->
            Just <| NextPrevious m n

        ( Just m, _ ) ->
            Just <| Previous m

        ( _, Just n ) ->
            Just <| Next n

        _ ->
            Nothing


type alias Model =
    { articles : Articles
    , page : Maybe Page
    }


type alias ApiResponse =
    { articles : Articles
    , next : Maybe String
    , previous : Maybe String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { articles = [], page = Nothing }, load "/api/articles/0/10" )


nextPage page =
    case page of
        Next a ->
            load a

        NextPrevious _ a ->
            load a

        _ ->
            Debug.todo "Should not have reached here"


load : String -> Cmd Msg
load page =
    Http.send NewArticles (Http.get (toPocketUrl page) decodeArticles)


toPocketUrl : String -> String
toPocketUrl page =
    "https://publicpocket.herokuapp.com" ++ page


decodeArticles : Json.Decode.Decoder ApiResponse
decodeArticles =
    Json.Decode.map3 ApiResponse
        (field "articles" <| Json.Decode.list decodeArticle)
        (maybe (field "next" Json.Decode.string))
        (maybe (field "previous" Json.Decode.string))


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
        Load page ->
            ( model, load page )

        NewArticles result ->
            case result of
                Err _ ->
                    ( model, Cmd.none )

                Ok apiResponse ->
                    let
                        page =
                            derive apiResponse
                    in
                        ( { model | articles = apiResponse.articles, page = page }, Cmd.none )


view : Model -> Html Msg
view { articles, page } =
    let
        titles =
            List.map (\article -> li [] [ text article.title ]) articles

        list_of_titles =
            [ ol [] titles ]
    in
        div [] (List.append list_of_titles (buttons page))


buttons : Maybe Page -> List (Html Msg)
buttons maybe_page =
    case maybe_page of
        Nothing ->
            []

        Just page ->
            case page of
                Next a ->
                    [ button [ onClick (Load a) ] [ text "Load More" ] ]

                NextPrevious a b ->
                    [ button [ onClick (Load b) ] [ text "Load More" ]
                    , button [ onClick (Load a) ] [ text "Load Previous" ]
                    ]

                Previous a ->
                    [ button [ onClick (Load a) ] [ text "Load Previous" ] ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }
