import { gql } from "@apollo/client";

export const GET_ME = gql`
  query getMe {
    me {
      email
    }
  }
`

export interface User {
    email: string;
}

export interface MeQuery {
    me: User
}