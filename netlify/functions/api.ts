import { Handler } from "@netlify/functions"

export const handler: Handler = async () => {
  await delay(1000)

  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Hello World" }),
  }
}

const delay = (ms: number) => new Promise((res) => setTimeout(res, ms))
