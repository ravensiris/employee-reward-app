import React from "react"

export interface Props {
  active?: boolean
  children?: React.ReactNode
  onClick?: React.MouseEventHandler<HTMLAnchorElement>
}

export default function AutocompleteItem({ active, children, onClick }: Props) {
  return (
    <a className={`dropdown-item ${active && "is-active"}`} onClick={onClick}>
      {children}
    </a>
  )
}
