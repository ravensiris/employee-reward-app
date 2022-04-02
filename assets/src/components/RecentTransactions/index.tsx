import type { Transaction } from "$queries/transactions"
import React from "react"
import RecentRow from "./RecentRow"
import RecentTable from "./RecentTable"

export interface Props {
  transactions: Transaction[]
}

export default function RecentTransactions({ transactions }: Props) {
  return (
    <RecentTable>
      {transactions.map(transaction => {
        return (
          <RecentRow
            key={transaction.id}
            toUser={transaction.toUser}
            amount={transaction.amount}
          />
        )
      })}
    </RecentTable>
  )
}
