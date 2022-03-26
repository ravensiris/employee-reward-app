import React, { useState } from "react"
import Navbar from "$/components/Navbar"
import Autocomplete from "$components/Autocomplete"
import { useLazyQuery } from "@apollo/client"
import { GET_USERS } from "$/operations/queries/user"
import type { UsersQuery, User } from "$/operations/queries/user"
import AutocompleteItem from "$/components/Autocomplete/AutocompleteItem"

export default function Send() {
  const [searchUser, { loading, data }] = useLazyQuery<UsersQuery>(GET_USERS)
  const [showItems, setShowItems] = useState(false)
  const [selectedUser, setSelectedUser] = useState<User>()
  const [inputValue, setInputValue] = useState("")
  const [hoverIndex, setHoverIndex] = useState(0)

  const shortUUID = (uuid: string | undefined) => {
    if (uuid === undefined) {
      return ""
    }
    const parts = uuid.split("-")
    return `${parts[0]}..${parts[1]}`
  }

  const userString = (user: User) => {
    return `${user.name} [${shortUUID(user.id)}]`
  }

  const selectUser = (user: User) => {
    setInputValue(userString(user))
    setSelectedUser(user)
    setShowItems(false)
  }

  const clearUser = () => {
    setInputValue("")
    setSelectedUser(undefined)
  }

  const itemDown = () => {
    const totalItems = data?.users.length || 1
    setHoverIndex(index => Math.min(index + 1, totalItems - 1))
  }

  const itemUp = () => {
    setHoverIndex(index => Math.max(index - 1, 0))
  }

  const onKeyDown: React.KeyboardEventHandler<HTMLInputElement> = event => {
    if (event.key === "ArrowDown") {
      event.preventDefault()
      itemDown()
    } else if (event.key === "ArrowUp") {
      event.preventDefault()
      itemUp()
    } else if (event.key === "Enter") {
      const user = data?.users.at(hoverIndex)
      if (user !== undefined) {
        selectUser(user)
      }
    }
  }

  const onChange: React.ChangeEventHandler<HTMLInputElement> = e => {
    const inputValue = e.target.value
    setInputValue(inputValue)
    searchUser({ variables: { name: inputValue } })
    setShowItems(true)
    setHoverIndex(0)
  }

  return (
    <>
      <Navbar />
      <div className="section">
        <Autocomplete
          onChange={onChange}
          loading={loading}
          active={showItems && !!data?.users.length}
          value={inputValue}
          onKeyDown={onKeyDown}
          placeholder="Name e.g John Smith"
          disabled={selectedUser === undefined}
          onClear={clearUser}
        >
          {data?.users &&
            data.users.map((user, i) => {
              return (
                <AutocompleteItem
                  key={user.id}
                  onClick={() => selectUser(user)}
                  active={i === hoverIndex}
                >
                  {`${user.name} [${shortUUID(user.id)}]`}
                </AutocompleteItem>
              )
            })}
        </Autocomplete>
      </div>
      <div className="section">
        <h1 className="title">
          Selected user: {selectedUser?.name || ""}[
          {shortUUID(selectedUser?.id)}]
        </h1>
      </div>
    </>
  )
}
