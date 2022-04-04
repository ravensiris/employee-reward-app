import App from "$/App"
import { cache, errorFlashStateVar, infoFlashStateVar } from "$/cache"
import Flash from "$components/Flash"
import "$sass/app.sass"
import * as AbsintheSocket from "@absinthe/socket"
import { createAbsintheSocketLink } from "@absinthe/socket-apollo-link"
import {
  ApolloClient,
  ApolloProvider,
  gql,
  HttpLink,
  split,
} from "@apollo/client"
import { getMainDefinition } from "@apollo/client/utilities"
import { Socket as PhoenixSocket } from "phoenix"
import React from "react"
import ReactDOM from "react-dom"
import { BrowserRouter } from "react-router-dom"
import { MeQuery } from "./operations/queries/user"
import PowApp from "./PowApp"

const isDev = !process.env.NODE_ENV || process.env.NODE_ENV === "development"

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
      <BrowserRouter>
        <PowApp />
      </BrowserRouter>
    </React.StrictMode>,
    powFormElement
  )
}

const rootElement = document.getElementById("root")

if (rootElement !== null) {
  // Creating this to fetch subscriptionToken
  const client = new ApolloClient({
    uri: "/api",
    cache: cache,
  })
  const SUBSCRIPTION_TOKEN_QUERY = gql`
    query getSubscriptionToken {
      me {
        id
        subscriptionToken
      }
    }
  `
  const subTokenResponse = client.query<MeQuery>({
    query: SUBSCRIPTION_TOKEN_QUERY,
  })
  const httpLink = new HttpLink({
    uri: "/api",
  })
  // Wait until subscribtionToken is fetched
  // then render the app
  subTokenResponse.then(meData => {
    const token = meData.data.me.subscriptionToken

    const phoenixSocket = new PhoenixSocket("/socket", {
      params: {
        subscriptionToken: token,
      },
    })

    // Wrap the Phoenix socket in an AbsintheSocket.
    const absintheSocket = AbsintheSocket.create(phoenixSocket)

    // Create an Apollo link from the AbsintheSocket instance.
    const absintheLink = createAbsintheSocketLink(absintheSocket)

    const splitLink = split(
      ({ query }) => {
        const definition = getMainDefinition(query)
        return (
          definition.kind === "OperationDefinition" &&
          definition.operation === "subscription"
        )
      },
      absintheLink,
      httpLink
    )

    client.setLink(splitLink)

    ReactDOM.render(
      <React.StrictMode>
        <ApolloProvider client={client}>
          <BrowserRouter>
            <App />
          </BrowserRouter>
        </ApolloProvider>
      </React.StrictMode>,
      rootElement
    )
  })
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
