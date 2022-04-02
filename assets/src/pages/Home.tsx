import CreditsShowcase from "$components/CreditsShowcase"
import Hello from "$components/Hello"
import Navbar from "$components/Navbar"
import { useMe } from "$queries/user"
import React from "react"

export default function Home() {
  const { loading, error, data } = useMe()
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
          credits={data?.me.balance?.balance}
        />
        <CreditsShowcase
          buttonTo="#"
          title="Received"
          buttonText="History"
          theme="is-danger"
          credits={data?.me.balance?.received}
        />
        <CreditsShowcase
          buttonTo="/send"
          title="Sent"
          buttonText="Send"
          theme="is-success"
          credits={data?.me.balance?.sent}
        />
      </section>
    </>
  )
}
