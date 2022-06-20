module Api.Todos exposing
    ( NewTodoBody
    , Todo
    , create
    , list
    )

import Http
import Json.Decode as Dec exposing (Decoder)
import Json.Encode as Enc exposing (Value)


type alias Todo =
    { text : String
    , completed : Bool
    , createdAt : String
    }


todoDecoder : Decoder Todo
todoDecoder =
    Dec.map3 Todo
        (Dec.field "text" Dec.string)
        (Dec.field "completed" Dec.bool)
        (Dec.field "created_at" Dec.string)


todosListDecoder : Decoder (List Todo)
todosListDecoder =
    Dec.field "todos" (Dec.list todoDecoder)


list : (Result Http.Error (List Todo) -> msg) -> Cmd msg
list onResult =
    Http.get
        { url = "api/todos"
        , expect = Http.expectJson onResult todosListDecoder
        }


type alias NewTodoBody =
    { text : String
    }


encodeNewTodoBody : NewTodoBody -> Value
encodeNewTodoBody body =
    Enc.object
        [ ( "text", Enc.string body.text )
        ]


todoCreatedDecoder : Decoder Todo
todoCreatedDecoder =
    Dec.field "todo" todoDecoder


create : NewTodoBody -> (Result Http.Error Todo -> msg) -> Cmd msg
create body onResult =
    Http.post
        { url = "api/todos"
        , body = Http.jsonBody (encodeNewTodoBody body)
        , expect = Http.expectJson onResult todoCreatedDecoder
        }
