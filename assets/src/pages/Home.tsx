import BalanceSummary from "$/components/BalanceSummary"
import Navbar from "$/components/Navbar"
import Hello from "$components/Hello"
import React from "react"

export default function Home() {
  return (
    <>
      <Navbar />
      <Hello />
      <BalanceSummary />
    </>
  )
}
