import CreditsInput from "$/components/CreditsInput"
import RecentTransactions from "$/components/RecentTransactions"
import { useSendCredits } from "$/operations/mutations/transactions"
import AutocompleteUser from "$components/AutocompleteUser"
import Navbar from "$components/Navbar"
import { useRecentTransactions } from "$queries/transactions"
import type { User } from "$queries/user"
import React, { useState } from "react"

export default function Send() {
  const [selectedUser, setSelectedUser] = useState<User>()
  const [amount, setAmount] = useState<number>(1)
  const [sendCreditsMutation] = useSendCredits()
  const sendCredits = () => {
    sendCreditsMutation({ variables: { to: selectedUser?.id, amount: amount } })
  }
  const { data: transactionsData } = useRecentTransactions()
  const transactions = transactionsData?.transactions

  return (
    <>
      <Navbar />
      <section className="section">
        <div className="container box">
          <div className="title">Send Ψ</div>
          <div className="block">
            <AutocompleteUser onSelected={setSelectedUser} />
          </div>
          <div className="block">
            <CreditsInput amount={amount} setAmount={setAmount} />
          </div>
          <div className="block">
            <button
              className="button is-primary w-full"
              onClick={sendCredits}
              disabled={!selectedUser}
            >
              Send
            </button>
          </div>
        </div>
      </section>
      <div className="section">
        <div className="box">
          <div className="title">Sent Ψ</div>
          {(transactions && (
            <RecentTransactions transactions={transactions} />
          )) || <div className="subtitle">No points sent yet!</div>}
        </div>
      </div>
    </>
  )
}
