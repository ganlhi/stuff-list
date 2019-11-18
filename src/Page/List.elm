module Page.List exposing (..)

import Element exposing (..)
import Element.Input as Input
import Stuff exposing (ListScope(..), Stuff, favorites)


type alias Model =
    ListScope


type Msg
    = ClickedDelete Stuff
    | CheckedFavorite Stuff Bool


view : List Stuff -> Model -> Element Msg
view stuffs scope =
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


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )
