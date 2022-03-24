import { gql } from "@apollo/client";

export const GET_ME = gql`
  query getMe {
    me {
      email
      name
    }
  }
`

export interface User {
    email: string;
    name: string;
}

export interface MeQuery {
    me: User
}