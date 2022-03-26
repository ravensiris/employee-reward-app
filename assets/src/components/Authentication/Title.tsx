import React from "react"

interface Props {
  /** Title text */
  children?: React.ReactNode
}

/**
 * Placeholder for a title section that is supposed to be hydrated in.
 */
export default function Title({ children }: Props) {
  return (
    <section className="hero is-primary">
      <div className="hero-body">
        <p className="title">{children}</p>
      </div>
    </section>
  )
}
