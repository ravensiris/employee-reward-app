import App from "$/App";
import { cache } from "$/cache";
import "$sass/app.sass";
import { ApolloClient, ApolloProvider } from "@apollo/client";
import React from "react";
import ReactDOM from "react-dom";
import { BrowserRouter } from "react-router-dom";

const client = new ApolloClient({
  uri: "/api",
  cache: cache,
});

ReactDOM.render(
  <React.StrictMode>
    <ApolloProvider client={client}>
      <BrowserRouter>
        <App />
      </BrowserRouter>
    </ApolloProvider>
  </React.StrictMode>,
  document.getElementById("root")
);
