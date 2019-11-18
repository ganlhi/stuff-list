module Page.Create exposing (..)

import Element exposing (..)
import Element.Input as Input


type alias Model =
    String


type Msg
    = ChangedNewName String
    | ClickedAdd


view : Model -> Element Msg
view name =
    column
        [ width fill
        , alignTop
        , padding 10
        ]
        [ row [ spacing 10 ]
            [ Input.text []
                { onChange = ChangedNewName
                , text = name
                , label = Input.labelHidden "Name"
                , placeholder = Nothing
                }
            , Input.button []
                { label = text "Add"
                , onPress = Just ClickedAdd
                }
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedNewName newName ->
            ( newName, Cmd.none )

        ClickedAdd ->
            ( model, Cmd.none )
