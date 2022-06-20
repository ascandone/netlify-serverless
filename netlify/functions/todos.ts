import { Handler } from "@netlify/functions"
import { supabase } from "../supabase"

export const handler: Handler = async (event, ctx) => {
  // event.queryStringParameters

  switch (event.httpMethod) {
    case "GET": {
      const { data: todos, error } = await supabase.from("todos").select("*")
      // TODO handle err

      return {
        statusCode: 200,
        body: JSON.stringify({ todos }),
      }
    }

    case "POST": {
      const { text } = JSON.parse(event.body!)

      const { data: todo, error } = await supabase
        .from("todos")
        .insert({
          text,
        })
        .single()

      console.log(todo)

      return {
        statusCode: 200,
        body: JSON.stringify({ todo }),
      }
    }

    default:
      return { statusCode: 400 }
  }
}
