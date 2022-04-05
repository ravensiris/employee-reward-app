import {
  useLazySummarizeMonth,
  useLazyUserTransactions,
} from "$/operations/queries/admin"
import { User } from "$/operations/queries/user"
import Navbar from "$components/Navbar"
import React, { useMemo, useState } from "react"

export default function AdminOverview() {
  const [selectedUser, setSelectedUser] = useState<User>()

  // used to init month input
  const now = new Date()
  const month = now.getMonth().toString().padStart(2, "0")
  const year = now.getFullYear().toString()
  const defaultDate = `${year}-${month}`

  // just the month string e.g. '2022-03'
  const [selectedMonth, setSelectedMonth] = useState(defaultDate)
  // actual selected month as Date object
  const selectedDate = useMemo(() => {
    const [yearStr, monthStr] = selectedMonth.split("-")
    const year = parseInt(yearStr)
    const month = parseInt(monthStr)
    if (isNaN(year) || isNaN(month)) {
      return
    }
    const date = new Date(year, month)
    return date
  }, [selectedMonth])

  const [summarizeMonth, { data: monthData }] = useLazySummarizeMonth()
  const [userTransactions, { data: userTransactionData }] =
    useLazyUserTransactions()

  return (
    <>
      <Navbar />
      <section className="section">
        <div className="container box">
          <div className="title">Summarize data for:</div>
          <div className="block">
            <label htmlFor="month" className="label">
              Month
            </label>
            <input
              className="input"
              type="month"
              name="month"
              id="month"
              value={selectedMonth}
              onChange={e => {
                const value = e.target.value
                setSelectedMonth(value)
              }}
            />
          </div>
          <div className="block">
            <button
              className="button is-primary w-full"
              onClick={() => {
                summarizeMonth({
                  variables: {
                    month: selectedDate?.toISOString(),
                  },
                })
              }}
            >
              Load
            </button>
          </div>
        </div>
      </section>
      {monthData?.summarizedMonth && monthData.summarizedMonth.length > 0 && (
        <section className="section">
          <div className="container box">
            <p className="title">Results</p>
            <div className="table-container">
              <table className="table is-striped whitespace-nowrap">
                <thead>
                  <tr>
                    <th>Id</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Balance</th>
                    <th>Received</th>
                    <th>Sent</th>
                  </tr>
                </thead>
                <tbody>
                  {monthData?.summarizedMonth.map(user => {
                    return (
                      <tr
                        key={user.id}
                        onClick={() => {
                          setSelectedUser(user)
                          userTransactions({
                            variables: {
                              month: selectedDate?.toISOString(),
                              userId: user.id,
                            },
                          })
                        }}
                        className={`is-clickable ${
                          user.id === selectedUser?.id && "is-selected"
                        }`}
                      >
                        <td>{user.id}</td>
                        <td>{user.name}</td>
                        <td>{user.email}</td>
                        <td>{user.balance?.balance}</td>
                        <td>{user.balance?.received}</td>
                        <td>{user.balance?.sent}</td>
                      </tr>
                    )
                  })}
                </tbody>
              </table>
            </div>
          </div>
        </section>
      )}
      {selectedUser &&
        userTransactionData?.userTransactions &&
        userTransactionData.userTransactions.length > 0 && (
          <section className="section">
            <div className="container box">
              <p className="title">{selectedUser.name}&apos;s transactions:</p>
              <div className="table-container">
                <table className="table is-striped whitespace-nowrap">
                  <thead>
                    <tr>
                      <th>Id</th>
                      <th>Amount</th>
                      <th>From Id</th>
                      <th>From Name</th>
                      <th>From Email</th>
                      <th>To Id</th>
                      <th>To Name</th>
                      <th>To Email</th>
                    </tr>
                  </thead>
                  <tbody>
                    {userTransactionData?.userTransactions.map(transaction => {
                      return (
                        <tr key={transaction.id}>
                          <td>{transaction.id}</td>
                          <td>{transaction.amount}</td>
                          <td>{transaction.fromUser?.id}</td>
                          <td>{transaction.fromUser?.name}</td>
                          <td>{transaction.fromUser?.email}</td>
                          <td>{transaction.toUser?.id}</td>
                          <td>{transaction.toUser?.name}</td>
                          <td>{transaction.toUser?.email}</td>
                        </tr>
                      )
                    })}
                  </tbody>
                </table>
              </div>
              <button className="button is-danger w-full">Remove</button>
            </div>
          </section>
        )}
    </>
  )
}
