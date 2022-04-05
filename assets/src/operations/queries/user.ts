import { gql, useLazyQuery, useQuery } from "@apollo/client"

export const GET_ME = gql`
  query getMe {
    me {
      id
      email
      name
      role
      balance {
        balance
        sent
        received
      }
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

export interface Balance {
  balance?: number
  sent?: number
  received?: number
}

export enum UserRole {
  MEMBER = "member",
  ADMIN = "admin",
}

export interface User {
  id?: string
  email?: string
  name?: string
  balance?: Balance
  subscriptionToken?: string
  role?: UserRole
}

export interface MeQuery {
  me: User
}

export interface UsersQuery {
  users: User[]
}

export const useMe = () => useQuery<MeQuery>(GET_ME)
export const useLazyUsers = () => useLazyQuery<UsersQuery>(GET_USERS)