import type { User } from "$queries/user"
import React from "react"

export interface Props {
  toUser?: User
  amount?: number
}

export default function RecentRow({ toUser, amount }: Props) {
  const show = toUser?.id && toUser.name && amount !== undefined
  return (
    (show && (
      <tr>
        <td>
          <abbr title={toUser.id}>{toUser.name}</abbr>
        </td>
        <td>
          {amount}
          <span className="font-bold">Ψ</span>
        </td>
      </tr>
    )) || <></>
  )
}
