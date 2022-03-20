import React from 'react'
import ReactDOM from 'react-dom'
import './index.css'
import App from './App'
import './sass/app.sass';
import {
  ApolloClient,
  InMemoryCache,
  ApolloProvider,
  useQuery,
  gql
} from "@apollo/client";

const ME_QUERY = gql`
  query getMe {
    me {
      id
      email
      role
    }
  }
`;

function Me(){
  const {loading, error, data} = useQuery(ME_QUERY);
  if (loading) return <p>Loading</p>;
  if (error) return <p>Error</p>;

  return <h1>Welcome {data.me.email}!</h1>;
}

const client = new ApolloClient({
  uri: '/api',
  cache: new InMemoryCache()
});

ReactDOM.render(
  <ApolloProvider client={client}>
    <Me />
  </ApolloProvider>,
  document.getElementById('root')
)
