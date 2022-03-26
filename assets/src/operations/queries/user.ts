import { gql } from "@apollo/client"

export const GET_ME = gql`
  query getMe {
    me {
      email
      name
    }
  }
`

export const GET_USERS = gql`
  query searchUser($name: String!) {
    users(name: $name) {
      id
      name
    }
  }
`

export interface User {
  id?: string
  email?: string
  name?: string
}

export interface MeQuery {
  me: User
}

export interface UsersQuery {
  users: User[]
}
