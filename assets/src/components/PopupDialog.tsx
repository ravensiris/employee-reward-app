import React from "react"

export interface Props {
  title?: string
  children?: React.ReactNode
  primaryButtonText?: string
  secondaryButtonText?: string
  type?: "is-success" | "is-danger"
  isActive?: boolean
  onDismiss?: React.MouseEventHandler<HTMLButtonElement>
  onPrimaryClick?: React.MouseEventHandler<HTMLButtonElement>
  onSecondaryClick?: React.MouseEventHandler<HTMLButtonElement>
}

export default function PopupDialog({
  title,
  children,
  primaryButtonText,
  secondaryButtonText,
  type,
  isActive,
  onDismiss,
  onPrimaryClick,
  onSecondaryClick,
}: Props) {
  return (
    <div className={`modal ${isActive && "is-active"}`}>
      <div className="modal-background"></div>
      <div className="modal-card">
        <header className="modal-card-head mx-3">
          <p className="modal-card-title">{title}</p>
          <button className="delete" aria-label="close" onClick={onDismiss} />
        </header>
        <section className="modal-card-body mx-3 capitalize-first-letter">
          {children}
        </section>
        <footer className="modal-card-foot mx-3">
          <button
            className={`button ${type || "is-success"}`}
            onClick={onPrimaryClick || onDismiss}
          >
            {primaryButtonText || "Ok"}
          </button>
          <button className="button" onClick={onSecondaryClick || onDismiss}>
            {secondaryButtonText || "Cancel"}
          </button>
        </footer>
      </div>
    </div>
  )
}
