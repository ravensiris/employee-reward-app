import React from "react"

export interface Props {
  /** Button's inner text */
  children: React.ReactNode
}

/**
 * Placeholder for a form link/button that is supposed to be hydrated in.
 */
export default function Button({ children }: Props) {
  return (
    <div className="control">
      <span className="button" suppressHydrationWarning>
        <a suppressHydrationWarning>{children}</a>
      </span>
    </div>
  )
}
