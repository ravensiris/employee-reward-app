import App from "$/App"
import { cache, errorFlashStateVar, infoFlashStateVar } from "$/cache"
import Flash from "$components/Flash"
import "$sass/app.sass"
import { ApolloClient, ApolloProvider } from "@apollo/client"
import React from "react"
import ReactDOM from "react-dom"
import { BrowserRouter } from "react-router-dom"
import PowApp from "./PowApp"

const isDev = !process.env.NODE_ENV || process.env.NODE_ENV === "development"

const client = new ApolloClient({
  uri: "/api",
  cache: cache,
})

interface AppApolloProviderProps {
  children?: React.ReactNode
}
const AppApolloProvider = ({ children }: AppApolloProviderProps) => {
  return <ApolloProvider client={client}>{children}</ApolloProvider>
}

const powFormElement = document.getElementById("pow-form")
if (powFormElement !== null) {
  // stop hydrate from complaining about whitespace
  if (isDev) {
    powFormElement.innerHTML = powFormElement.innerHTML.replace(
      /(?<=>|^)\s+(?=<|$)/g,
      ""
    )
  }
  ReactDOM.hydrate(
    <React.StrictMode>
      <AppApolloProvider>
        <BrowserRouter>
          <PowApp />
        </BrowserRouter>
      </AppApolloProvider>
    </React.StrictMode>,
    powFormElement
  )
}

const rootElement = document.getElementById("root")

if (rootElement !== null) {
  ReactDOM.render(
    <React.StrictMode>
      <AppApolloProvider>
        <BrowserRouter>
          <App />
        </BrowserRouter>
      </AppApolloProvider>
    </React.StrictMode>,
    rootElement
  )
}

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
