import { Handler } from "@netlify/functions"
import { prisma } from "../prisma"

export const handler: Handler = async (event) => {
  switch (event.httpMethod) {
    case "GET": {
      const todos = await prisma.todos.findMany()

      return {
        statusCode: 200,
        body: JSON.stringify({ todos }),
      }
    }

    case "POST": {
      const { text } = JSON.parse(event.body!)

      const todo = await prisma.todos.create({
        data: {
          text,
        },
      })

      return {
        statusCode: 200,
        body: JSON.stringify({ todo }),
      }
    }

    default:
      return { statusCode: 400 }
  }
}

// @ts-ignore
BigInt.prototype.toJSON = function () {
  return this.toString()
}
