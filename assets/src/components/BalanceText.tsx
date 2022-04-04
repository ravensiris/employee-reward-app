import { Balance, useMe } from "$queries/user"
import { gql } from "@apollo/client"
import React, { useEffect } from "react"

export interface Props {
  type: "balance" | "received" | "sent"
}

export const UPDATE_BALANCE_SUBSCRIPTION = gql`
  subscription onBalanceUpdate {
    updateBalance {
      balance
      sent
      received
    }
  }
`
export default function BalanceText({ type }: Props) {
  const { data, subscribeToMore } = useMe()
  const balance = data?.me.balance

  useEffect(() => {
    subscribeToMore({
      document: UPDATE_BALANCE_SUBSCRIPTION,
      updateQuery: (prev, { subscriptionData }: any) => {
        if (!subscriptionData.data) {
          return prev
        }
        const newBalance: Balance = subscriptionData.data.updateBalance
        return Object.assign({}, { me: { ...prev.me, balance: newBalance } })
      },
    })
  }, [subscribeToMore])

  if (balance === undefined) {
    return <>...</>
  }

  return (
    <>
      <span>{balance[type]}</span> <span className="font-bold">Ψ</span>
    </>
  )
}
