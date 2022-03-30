import { gql } from "@apollo/client"
import type { User } from "$queries/user"

export const GET_RECENT_TRANSACTIONS = gql`
  query getRecentTransactions {
    transactions {
      id
      amount
      fromUser{
        id
        name
      }
      toUser {
        id
        name
      }
    }
  }
`

export interface Transaction {
  id: string
  amount?: number
  fromUser: User
  toUser: User
}

export interface TransactionsQuery {
  transactions: Transaction[]
}
