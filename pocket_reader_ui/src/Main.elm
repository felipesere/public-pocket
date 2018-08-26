module Main exposing (..)

import Json.Decode exposing (field, maybe)
import Html exposing (Html, text, div, ol, li, button, p, span, footer, a)
import Html.Events exposing (onClick)
import Html.Attributes exposing (target, class, datetime, href)
import Http exposing (send)
import Browser


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



-- VIEWS


view : Model -> Html Msg
view { articles, page } =
    div [] (List.append (List.map viewArticle articles) [ pagination page ])


viewArticle : Article -> Html Msg
viewArticle article =
    div [ class "card" ] [ viewHeader article, viewContent article, viewFooter article ]


viewHeader { title } =
    Html.header [ class "card-header" ] [ p [ class "card-header-title" ] [ text title ] ]


viewContent { content, time, tags } =
    div [ class "card-content" ]
        [ div [ class "content article-structure" ]
            [ div [] [ text content ]
            , Html.time [ datetime time.short ] [ text time.long ]
            , div [ class "tags" ] (List.map viewTag tags)
            ]
        ]


viewFooter { link } =
    footer [ class "card-footer" ]
        [ a [ href link, class "card-footer-item", target "_blank" ] [ text "Open" ]
        , a [ href (pocket link), class "card-footer-item", target "_blank" ] [ text "Save to Pocket" ]
        ]


pocket : String -> String
pocket link =
    "https://getpocket.com/edit.php?url=" ++ link


viewTag : String -> Html Msg
viewTag tagname =
    span [ class "tag is-info is-rounded" ] [ text tagname ]


pagination : Maybe Page -> Html Msg
pagination maybe_page =
    let
        bttns =
            maybe_page
                |> Maybe.map buttons
                |> Maybe.withDefault []
    in
        Html.nav [ class "pagination is-right" ] bttns


buttons : Page -> List (Html Msg)
buttons page =
    let
        next a =
            button [ class "pagination-next", onClick (Load a) ] [ text "Next page" ]

        previous a =
            button [ class "pagination-previous", onClick (Load a) ] [ text "Previous Page" ]
    in
        case page of
            Next a ->
                [ next a ]

            NextPrevious a b ->
                [ previous b, next a ]

            Previous a ->
                [ previous a ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }
