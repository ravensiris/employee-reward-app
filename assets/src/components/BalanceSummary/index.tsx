import React from "react"
import Balance from "./Balance"
import Received from "./Received"
import Sent from "./Sent"

export default function BalanceSummary() {
  return (
    <section className="section tile is-ancestor">
      <Balance />
      <Received />
      <Sent />
    </section>
  )
}
