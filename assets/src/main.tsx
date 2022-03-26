import App from "$/App"
import { cache, errorFlashStateVar, infoFlashStateVar } from "$/cache"
import Flash from "$components/Flash"
import "$sass/app.sass"
import { ApolloClient, ApolloProvider } from "@apollo/client"
import React from "react"
import ReactDOM from "react-dom"
import { BrowserRouter } from "react-router-dom"

const client = new ApolloClient({
  uri: "/api",
  cache: cache,
})

const rootElement = document.getElementById("root")

ReactDOM.hydrate(
  <React.StrictMode>
    <ApolloProvider client={client}>
      <BrowserRouter>
        <App />
      </BrowserRouter>
    </ApolloProvider>
  </React.StrictMode>,
  rootElement
)

const flashErrorElement = document.getElementById("flash-error")
ReactDOM.hydrate(
  <React.StrictMode>
    <Flash flashState={errorFlashStateVar} />
  </React.StrictMode>,
  flashErrorElement
)
const flashInfoElement = document.getElementById("flash-info")
ReactDOM.hydrate(
  <React.StrictMode>
    <Flash flashState={infoFlashStateVar} />
  </React.StrictMode>,
  flashInfoElement
)
