import { User } from "$/operations/queries/user"
import Navbar from "$components/Navbar"
import React, { useState } from "react"

export default function AdminOverview() {
  const [selectedUser, setSelectedUser] = useState<User>()

  const now = new Date()
  const monthNow = now.getMonth().toString().padStart(2, "0")
  const yearNow = now.getFullYear().toString()
  const monthDefault = `${yearNow}-${monthNow}`

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
              defaultValue={monthDefault}
            />
          </div>
          <div className="block">
            <button className="button is-primary w-full">Load</button>
          </div>
        </div>
      </section>
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
                <tr>
                  <td>653ae27e-bd62-49f4-85b4-2b87ce3b2e34</td>
                  <td>Aaron Smith</td>
                  <td>aaron.smith@example.org</td>
                  <td>10 Ψ</td>
                  <td>0 Ψ</td>
                  <td>40 Ψ</td>
                </tr>
                <tr>
                  <td>653ae27e-bd62-49f4-85b4-2b87ce3b2e34</td>
                  <td>Aaron Smith</td>
                  <td>aaron.smith@example.org</td>
                  <td>10 Ψ</td>
                  <td>0 Ψ</td>
                  <td>40 Ψ</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </section>
    </>
  )
}
