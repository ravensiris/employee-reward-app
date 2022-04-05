import { gql, useLazyQuery, useMutation } from "@apollo/client"
import { Transaction } from "./transactions"
import { User } from "./user"

export const ADMIN_SUMMARIZED_MONTH = gql`
    query summarizeMonth($month: NaiveDateTime!){
        summarizedMonth(month: $month){
            id
            name
            email
            balance {
                balance
                sent
                received
            }
        }
    }
`

export const ADMIN_USER_TRANSACTIONS = gql`
    query userTransactions($month: NaiveDateTime!, $userId: UUID4!){
        userTransactions(month: $month, userId: $userId){
            id
            amount
            fromUser {
                id
                name
                email
            }
            toUser {
                id
                name
                email
            }
        }
    }
`

export const ADMIN_DELETE_TRANSACTION = gql`
    mutation deleteTransaction($transactionId: UUID4!){
        deleteTransaction(transactionId: $transactionId){
            id
        }
    }
`

export interface SummarizedMonthQuery{
    summarizedMonth: User[]
}

export interface UserTransactionsQuery{
    userTransactions: Transaction[]
}

export interface DeleteTransactionMutation{
    userTransactions: Transaction[]
}

export const useLazySummarizeMonth = () => useLazyQuery<SummarizedMonthQuery>(ADMIN_SUMMARIZED_MONTH) 
export const useLazyUserTransactions = () => useLazyQuery<UserTransactionsQuery>(ADMIN_USER_TRANSACTIONS) 
export const useDeleteTransactionMutation = () => useMutation<DeleteTransactionMutation>(ADMIN_DELETE_TRANSACTION) 