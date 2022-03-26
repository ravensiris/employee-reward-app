import React from "react"

interface SubmitProps {
  /** Button's inner text */
  children?: React.ReactNode
}

/**
 * Placeholder for a submit button that is supposed to be hydrated in.
 */
export default function Submit({ children }: SubmitProps) {
  return (
    <div>
      <button>{children}</button>
    </div>
  )
}
