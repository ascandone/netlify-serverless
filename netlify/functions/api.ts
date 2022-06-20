exports.handler = async function (event, context) {
  await delay(1000)

  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Hello World" }),
  }
}

const delay = (ms: number) => new Promise((res) => setTimeout(res, ms))
