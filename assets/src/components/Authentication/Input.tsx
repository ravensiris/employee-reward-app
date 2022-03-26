import React from "react"

export interface Props {
  /** Input's label text */
  children?: React.ReactNode
}

/**
 * Placeholder for an input form field that is supposed to be hydrated in.
 */
export default function Input({ children }: Props) {
  return (
    <div className="field">
      <label suppressHydrationWarning>{children}</label>
      <div className="control">
        <input className="input" suppressHydrationWarning />
        <span
          className="input-error"
          dangerouslySetInnerHTML={{ __html: "" }}
          suppressHydrationWarning
        />
      </div>
    </div>
  )
}
