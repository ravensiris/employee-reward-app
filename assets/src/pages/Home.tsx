import BalanceText from "$components/BalanceText"
import CreditsShowcase from "$components/CreditsShowcase"
import Hello from "$components/Hello"
import Navbar from "$components/Navbar"
import React from "react"

export default function Home() {
  return (
    <>
      <Navbar />
      <Hello />

      <section className="section tile is-ancestor">
        <CreditsShowcase
          buttonTo="#"
          title="Balance"
          buttonText="Store"
          theme="is-info"
          credits={<BalanceText type="balance" />}
        />
        <CreditsShowcase
          buttonTo="#"
          title="Received"
          buttonText="History"
          theme="is-danger"
          credits={<BalanceText type="received" />}
        />
        <CreditsShowcase
          buttonTo="/send"
          title="Sent"
          buttonText="Send"
          theme="is-success"
          credits={<BalanceText type="sent" />}
        />
      </section>
    </>
  )
}
