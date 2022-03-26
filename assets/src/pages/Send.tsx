import Navbar from "$/components/Navbar"
import AutocompleteUser from "$components/AutocompleteUser"
import type { User } from "$queries/user"
import React, { useState } from "react"

export default function Send() {
  const [selectedUser, setSelectedUser] = useState<User>()
  return (
    <>
      <Navbar />
      <div className="section">
        <AutocompleteUser onSelected={setSelectedUser} />
        <h1>{selectedUser && selectedUser.name}</h1>
      </div>
    </>
  )
}
