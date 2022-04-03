import CreditsInput from "$/components/CreditsInput"
import PopupDialog from "$/components/PopupDialog"
import RecentTransactions from "$/components/RecentTransactions"
import { useSendCredits } from "$/operations/mutations/transactions"
import AutocompleteUser from "$components/AutocompleteUser"
import Navbar from "$components/Navbar"
import { useRecentTransactions } from "$queries/transactions"
import { useMe, User } from "$queries/user"
import React, { useState } from "react"

export default function Send() {
  const [selectedUser, setSelectedUser] = useState<User>()
  const [amount, setAmount] = useState<number>(1)
  const [
    sendCreditsMutation,
    { error: sendingError, reset: resetSendingError },
  ] = useSendCredits()
  const sendCredits = () => {
    sendCreditsMutation({ variables: { to: selectedUser?.id, amount: amount } })
  }
  const { data: transactionsData } = useRecentTransactions()
  const transactions = transactionsData?.transactions
  const { data: meData } = useMe()
  const balance = meData?.me.balance?.balance

  return (
    <>
      <Navbar />
      <PopupDialog
        onDismiss={resetSendingError}
        isActive={!!sendingError}
        title="Error"
        type="is-danger"
      >
        {sendingError?.message}
      </PopupDialog>
      <section className="section">
        <div className="container box">
          <div className="title">Send Ψ</div>
          <div className="block">
            <AutocompleteUser onSelected={setSelectedUser} />
          </div>
          <div className="block">
            <CreditsInput amount={amount} setAmount={setAmount} />
          </div>
          {balance !== undefined && (
            <div className="block">
              <hr />
              <p>Your balance: {balance}</p>
            </div>
          )}
          <div className="block">
            <button
              className="button is-primary w-full"
              onClick={sendCredits}
              disabled={
                !selectedUser || balance === undefined || balance < amount
              }
            >
              Send
            </button>
          </div>
        </div>
      </section>
      <div className="section">
        <div className="box">
          <div className="title">Recently sent Ψ</div>
          {(transactions && (
            <RecentTransactions transactions={transactions} />
          )) || <div className="subtitle">No points sent yet!</div>}
        </div>
      </div>
    </>
  )
}
