import CreditsShowcase from "$components/CreditsShowcase"
import Hello from "$components/Hello"
import Navbar from "$components/Navbar"
import { GET_ME, MeQuery } from "$queries/user"
import { useQuery } from "@apollo/client"
import React from "react"

export default function Home() {
  const { loading, error, data } = useQuery<MeQuery>(GET_ME)
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
