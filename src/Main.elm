module Main exposing (main)

import Api.Todos
import Browser
import Html exposing (..)
import Html.Attributes exposing (class, placeholder, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Http exposing (Error(..))
import RemoteData exposing (RemoteData(..))


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Flags =
    {}


type alias Model =
    { remoteData : RemoteData Http.Error (List Api.Todos.Todo)
    , inputText : String
    }


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { remoteData = NotAsked
      , inputText = ""
      }
    , Cmd.none
    )


type Msg
    = ClickedFetch
    | GotData (Result Http.Error (List Api.Todos.Todo))
    | InputTodo String
    | SubmitTodo
    | GotTodo (Result Http.Error Api.Todos.Todo)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedFetch ->
            ( { model | remoteData = Loading }
            , Api.Todos.list GotData
            )

        GotData result ->
            ( { model | remoteData = RemoteData.fromResult result }
            , Cmd.none
            )

        InputTodo value ->
            ( { model | inputText = value }
            , Cmd.none
            )

        SubmitTodo ->
            case validateText model.inputText of
                Err _ ->
                    ( model
                    , Cmd.none
                    )

                Ok text ->
                    ( { model | inputText = "" }
                    , Api.Todos.create { text = text } GotTodo
                    )

        GotTodo result ->
            ( case ( result, model.remoteData ) of
                ( Ok newTodo, Success todos ) ->
                    { model | remoteData = Success (newTodo :: todos) }

                _ ->
                    model
            , Cmd.none
            )


validateText : String -> Result String String
validateText str =
    case String.trim str of
        "" ->
            Err "Invalid text"

        trimmed ->
            Ok trimmed


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


btnCls : Attribute msg
btnCls =
    class "px-4 py-2 leading-none bg-zinc-900 text-white rounded hover:bg-zinc-900/90"


view : Model -> Html Msg
view model =
    div [ class "p-2" ]
        [ form [ class "flex", onSubmit SubmitTodo ]
            [ input
                [ class "border rounded focus:ring focus:outline-none px-2"
                , placeholder "insert text"
                , value model.inputText
                , onInput InputTodo
                ]
                []
            , div [ class "w-2" ] []
            , button
                [ btnCls
                , type_ "submit"
                ]
                [ text "Submit" ]
            ]
        , hr [ class "my-5" ] []
        , button
            [ btnCls
            , onClick ClickedFetch
            ]
            [ text "Fetch data" ]
        , hr [ class "my-5" ] []
        , case model.remoteData of
            NotAsked ->
                div [ class "text-gray-500" ] [ text "No data yet" ]

            Loading ->
                text "loading..."

            Success todos ->
                ul [ class "list-disc list-inside" ] (todos |> List.map viewTodo)

            Failure err ->
                div [ class "text-red-800" ] [ text "Error: ", pre [] [ text (errToString err) ] ]
        ]


errToString : Http.Error -> String
errToString err =
    case err of
        BadUrl u ->
            "Bad url: " ++ u

        Timeout ->
            "Timeout"

        NetworkError ->
            "NetworkError"

        BadStatus s ->
            "BadStatus: " ++ String.fromInt s

        BadBody b ->
            "BadBody: " ++ b


viewTodo : Api.Todos.Todo -> Html msg
viewTodo todo =
    li []
        [ text todo.text
        , text " "
        , text <|
            if todo.completed then
                "(completed)"

            else
                ""
        ]
