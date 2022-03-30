import Navbar from "$/components/Navbar"
import { SEND_CREDITS } from "$/operations/mutations/transactions"
import AutocompleteUser from "$components/AutocompleteUser"
import type { TransactionsQuery } from "$queries/transactions"
import { GET_RECENT_TRANSACTIONS } from "$queries/transactions"
import type { User } from "$queries/user"
import { useMutation, useQuery } from "@apollo/client"
import React, { useState } from "react"

export default function Send() {
  const [selectedUser, setSelectedUser] = useState<User>()
  const [amount, setAmount] = useState<number>(1)
  const { loading, error, data } = useQuery<TransactionsQuery>(
    GET_RECENT_TRANSACTIONS
  )
  const [
    sendCreditsMutation,
    { data: scData, loading: scLoading, error: scError },
  ] = useMutation<TransactionsQuery>(SEND_CREDITS)
  const sendCredits = () => {
    sendCreditsMutation({ variables: { to: selectedUser?.id, amount: amount } })
  }

  const onChange = e => {
    const value = parseInt(e.target.value)
    if (value !== undefined && !isNaN(value)) {
      setAmount(value)
    }
  }
  return (
    <>
      <Navbar />
      <section className="section">
        <AutocompleteUser onSelected={setSelectedUser} />
      </section>
      {selectedUser && (
        <section className="section">
          <div className="columns is-centered">
            <div className="column is-three-fifths">
              <div className="field has-addons">
                <div className="control">
                  <input
                    type="number"
                    className="input is-large"
                    value={amount}
                    onChange={onChange}
                  />
                </div>
                <div className="control">
                  <button
                    className="button is-primary is-large"
                    onClick={sendCredits}
                  >
                    Send
                  </button>
                </div>
              </div>
            </div>
          </div>
        </section>
      )}
      <section className="section">
        <table className="table w-full">
          <thead>
            <tr>
              <th>From</th>
              <th>To</th>
              <th>Amount</th>
            </tr>
          </thead>
          <tbody>
            {data?.transactions &&
              data.transactions.map(transaction => {
                return (
                  <tr key={transaction.id}>
                    <td>
                      <abbr title={transaction.fromUser.id}>
                        {transaction.fromUser.name}
                      </abbr>
                    </td>
                    <td>
                      <abbr title={transaction.toUser.id}>
                        {transaction.toUser.name}
                      </abbr>
                    </td>
                    <td>{transaction.amount}</td>
                  </tr>
                )
              })}
          </tbody>
        </table>
      </section>
    </>
  )
}
