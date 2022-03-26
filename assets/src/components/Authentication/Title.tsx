import React from "react"

interface InputProps {
  /** Title text */
  children?: React.ReactNode
}

/**
 * Placeholder for a title section that is supposed to be hydrated in.
 */
export default function Input({ children }: InputProps) {
  return (
    <section>
      <div>
        <p>{children}</p>
      </div>
    </section>
  )
}
