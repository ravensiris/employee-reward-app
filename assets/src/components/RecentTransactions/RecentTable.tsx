import React from "react"

export interface Props {
  children?: React.ReactNode
}

export default function RecentTable({ children }: Props) {
  return (
    <table className="table w-full">
      <thead>
        <tr>
          <th>To</th>
          <th>Amount</th>
        </tr>
      </thead>
      <tbody>{children}</tbody>
    </table>
  )
}
