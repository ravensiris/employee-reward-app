import React from "react"
import { Link, To } from "react-router-dom"

interface Props {
  title: string
  buttonText: string
  buttonTo: To
  theme: "is-info" | "is-danger" | "is-success"
  credits?: string | number
}
export default function CreditsShowcase({
  title,
  buttonText,
  buttonTo,
  theme,
  credits,
}: Props) {
  return (
    <div className={`tile is-parent is-vertical ${theme}`}>
      <div className={`tile is-child notification ${theme}`}>
        <p className="title">{title}</p>
        <p className="subtitle">
          {credits === undefined ? "..." : credits}{" "}
          <span className="font-bold">Ψ</span>
        </p>
        <div className="buttons">
          <Link className={`button is-light ${theme}`} to={buttonTo}>
            {buttonText}
          </Link>
        </div>
      </div>
    </div>
  )
}
