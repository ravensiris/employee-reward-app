import { useMe } from "$queries/user"
import React from "react"

export interface Props {
  type: "balance" | "received" | "sent"
}

export default function BalanceText({ type }: Props) {
  const { data } = useMe()
  const balance = data?.me.balance
  if (balance === undefined) {
    return <>...</>
  }

  return (
    <>
      <span>{balance[type]}</span> <span className="font-bold">Ψ</span>
    </>
  )
}
