module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Http
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
    { remoteData : RemoteData Http.Error String
    }


init : Flags -> ( Model, Cmd Msg )
init _ =
    ( { remoteData = NotAsked }
    , Cmd.none
    )


type Msg
    = ClickedFetch
    | GotData (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedFetch ->
            ( { model | remoteData = Loading }
            , Http.get
                { url = "/.netlify/functions/api"
                , expect = Http.expectString GotData
                }
            )

        GotData result ->
            ( { model | remoteData = RemoteData.fromResult result }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div [ class "p-2" ]
        [ case model.remoteData of
            NotAsked ->
                button
                    [ class "px-5 py-3 leading-none bg-zinc-900 text-white rounded-sm"
                    , onClick ClickedFetch
                    ]
                    [ text "Fetch data" ]

            Loading ->
                text "loading..."

            Success data ->
                div [] [ text "Fetched data: ", pre [] [ text data ] ]

            Failure _ ->
                text "err"
        ]
