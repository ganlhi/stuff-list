module Main exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Element exposing (..)
import Element.Background as Background
import Element.Input as Input
import Stuff exposing (Stuff, add, delete, favorites, numberOfFavorites, setFavorite)
import Url exposing (Url)


type Msg
    = NoOp
    | ClickedDelete Stuff
    | CheckedFavorite Stuff Bool
    | ClickedLink UrlRequest
    | ChangedUrl Url
    | ChangedNewStuffName String
    | ClickedAdd


type alias Model =
    { key : Key
    , list : List Stuff
    , page : Page
    , newStuffName : Maybe String
    }


type ListScope
    = All
    | Favorites


type Page
    = ListPage ListScope
    | CreatePage



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
    ( { key = key, list = [], page = urlToPage url, newStuffName = Nothing }
    , Cmd.none
    )



-- Updates


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        ClickedDelete stuff ->
            ( { model | list = delete stuff model.list }, Cmd.none )

        CheckedFavorite stuff checked ->
            ( { model | list = setFavorite stuff checked model.list }, Cmd.none )

        ClickedLink urlRequest ->
            onClickedLink urlRequest model

        ChangedUrl url ->
            onUrlChanged url model

        ChangedNewStuffName text ->
            let
                name =
                    if String.length text > 0 then
                        Just text

                    else
                        Nothing
            in
            ( { model | newStuffName = name }, Cmd.none )

        ClickedAdd ->
            ( { model | newStuffName = Nothing, list = add model.newStuffName model.list }, Cmd.none )


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
            CreatePage

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
                    listView model.list listScope

                CreatePage ->
                    createView model.newStuffName
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


listView : List Stuff -> ListScope -> Element Msg
listView stuffs scope =
    let
        list =
            case scope of
                All ->
                    stuffs

                Favorites ->
                    stuffs |> favorites

        content =
            if List.length list == 0 then
                [ paragraph []
                    [ text "No stuff here! You should "
                    , link [] { url = "/new", label = text "add one" }
                    , text "..."
                    ]
                ]

            else
                List.map listItem list
    in
    column
        [ width fill
        , alignTop
        , padding 10
        ]
        content


listItem : Stuff -> Element Msg
listItem stuff =
    row [ spacing 10 ]
        [ text stuff.text
        , Input.checkbox []
            { icon = Input.defaultCheckbox
            , checked = stuff.favorite
            , label = Input.labelHidden "Favorite"
            , onChange = CheckedFavorite stuff
            }
        , Input.button []
            { label = text "X"
            , onPress = Just (ClickedDelete stuff)
            }
        ]


createView : Maybe String -> Element Msg
createView newStuffName =
    column
        [ width fill
        , alignTop
        , padding 10
        ]
        [ row [ spacing 10 ]
            [ Input.text []
                { onChange = ChangedNewStuffName
                , text = Maybe.withDefault "" newStuffName
                , label = Input.labelHidden "Name"
                , placeholder = Nothing
                }
            , Input.button []
                { label = text "Add"
                , onPress = Just ClickedAdd
                }
            ]
        ]
