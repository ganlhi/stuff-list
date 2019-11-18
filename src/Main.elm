module Main exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Element exposing (..)
import Element.Background as Background
import Element.Input as Input
import Page.Create
import Page.List exposing (Msg(..))
import Stuff exposing (ListScope(..), Stuff, add, delete, favorites, numberOfFavorites, setFavorite)
import Url exposing (Url)


type Msg
    = NoOp
    | ClickedLink UrlRequest
    | ChangedUrl Url
    | GotCreateMsg Page.Create.Msg
    | GotListMsg Page.List.Msg


type alias Model =
    { key : Key
    , list : List Stuff
    , page : Page
    }


type Page
    = ListPage ListScope
    | CreatePage String



-- Main


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        }


init : () -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    ( { key = key, list = [], page = urlToPage url }
    , Cmd.none
    )



-- Updates


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        GotCreateMsg createMsg ->
            case model.page of
                CreatePage newName ->
                    toCreate model createMsg (Page.Create.update createMsg newName)

                _ ->
                    ( model, Cmd.none )

        GotListMsg listMsg ->
            case model.page of
                ListPage scope ->
                    toList model listMsg (Page.List.update listMsg scope)

                _ ->
                    ( model, Cmd.none )

        ClickedLink urlRequest ->
            onClickedLink urlRequest model

        ChangedUrl url ->
            onUrlChanged url model


toCreate : Model -> Page.Create.Msg -> ( Page.Create.Model, Cmd Page.Create.Msg ) -> ( Model, Cmd Msg )
toCreate model msg ( name, cmd ) =
    case msg of
        Page.Create.ChangedNewName _ ->
            ( { model | page = CreatePage name }, Cmd.map GotCreateMsg cmd )

        Page.Create.ClickedAdd ->
            let
                newList =
                    add name model.list
            in
            ( { model | list = newList, page = ListPage All }, Cmd.none )


toList : Model -> Page.List.Msg -> ( Page.List.Model, Cmd Page.List.Msg ) -> ( Model, Cmd Msg )
toList model msg _ =
    case msg of
        ClickedDelete stuff ->
            ( { model | list = delete stuff model.list }, Cmd.none )

        CheckedFavorite stuff checked ->
            ( { model | list = setFavorite stuff checked model.list }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- Navigation


onClickedLink : UrlRequest -> Model -> ( Model, Cmd Msg )
onClickedLink urlRequest model =
    case urlRequest of
        Internal url ->
            ( model
            , Nav.pushUrl model.key (Url.toString url)
            )

        External url ->
            ( model
            , Nav.load url
            )


onUrlChanged : Url -> Model -> ( Model, Cmd Msg )
onUrlChanged url model =
    ( { model | page = urlToPage url }, Cmd.none )


urlToPage : Url -> Page
urlToPage url =
    case url.path of
        "/list/all" ->
            ListPage All

        "/list/favorites" ->
            ListPage Favorites

        "/new" ->
            CreatePage ""

        "" ->
            ListPage All

        _ ->
            ListPage All



-- TODO handle 404
-- View


view : Model -> Document Msg
view model =
    let
        content =
            case model.page of
                ListPage listScope ->
                    Page.List.view model.list listScope |> Element.map GotListMsg

                CreatePage newStuffName ->
                    Page.Create.view newStuffName |> Element.map GotCreateMsg
    in
    { title = "Stuff List"
    , body =
        [ layout [] <|
            row [ height fill, width fill, spacing 10 ]
                [ sidebar model
                , content
                ]
        ]
    }


sidebar : Model -> Element Msg
sidebar model =
    column
        [ height fill
        , width <| px 200
        , padding 10
        , alignTop
        , Background.color <| rgb255 92 99 118
        ]
        [ el [] <| text "Stuff List"
        , menu model
        ]


menu : Model -> Element Msg
menu model =
    column
        [ width fill
        , alignTop
        ]
        [ link []
            { url = "/list/all"
            , label = text "Complete list"
            }
        , link []
            { url = "/list/favorites"
            , label = text <| "Favorites (" ++ (numberOfFavorites model.list |> String.fromInt) ++ ")"
            }
        , link []
            { url = "/new"
            , label = text <| "Add stuff"
            }
        ]
