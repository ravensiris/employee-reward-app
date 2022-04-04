import { gql, useQuery } from "@apollo/client"
import type { User } from "$queries/user"

export const GET_RECENT_TRANSACTIONS = gql`
  query getRecentTransactions {
    transactions(direction: OUTGOING) {
      id
      amount
      toUser {
        id
        name
      }
    }
  }
`

export interface Transaction {
  id?: string
  amount?: number
  fromUser?: User
  toUser?: User
}

export interface TransactionsQuery {
  transactions: Transaction[]
}

export const useRecentTransactions = () => useQuery<TransactionsQuery>(GET_RECENT_TRANSACTIONS)