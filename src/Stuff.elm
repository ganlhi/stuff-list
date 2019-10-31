module Stuff exposing (..)


type alias Stuff =
    { text : String
    , favorite : Bool
    }


favorites : List Stuff -> List Stuff
favorites =
    List.filter .favorite


numberOfFavorites : List Stuff -> Int
numberOfFavorites list =
    list |> favorites |> List.length


delete : Stuff -> List Stuff -> List Stuff
delete stuff =
    List.filter ((/=) stuff)


setFavorite : Stuff -> Bool -> List Stuff -> List Stuff
setFavorite stuff checked =
    let
        setOne s =
            if s == stuff then
                { s | favorite = checked }

            else
                s
    in
    List.map setOne


add : Maybe String -> List Stuff -> List Stuff
add name list =
    case name of
        Nothing ->
            list

        Just text ->
            if String.length text > 0 then
                list ++ [ { text = text, favorite = False } ]

            else
                list
