import { setTimeout as delay } from "timers/promises"

exports.handler = async function (event, context) {
  await delay(1000)

  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Hello World" }),
  }
}
