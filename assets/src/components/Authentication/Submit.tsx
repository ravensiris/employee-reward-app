import React from "react"

export interface Props {
  /** Button's inner text */
  children?: React.ReactNode
}

/**
 * Placeholder for a submit button that is supposed to be hydrated in.
 */
export default function Submit({ children }: Props) {
  return (
    <div className="control">
      <button className="button is-primary" type="submit">
        {children}
      </button>
    </div>
  )
}
