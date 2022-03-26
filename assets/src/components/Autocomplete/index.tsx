import React from "react"

export interface Props {
  placeholder?: string
  active?: boolean
  disabled?: boolean
  loading?: boolean
  value?: string
  children?: React.ReactNode
  onClear?: React.MouseEventHandler<HTMLButtonElement>
  onChange?: React.ChangeEventHandler<HTMLInputElement>
  onKeyDown?: React.KeyboardEventHandler<HTMLInputElement>
}

export default function Autocomplete({
  placeholder,
  active,
  disabled,
  value,
  loading,
  children,
  onChange,
  onKeyDown,
  onClear,
}: Props) {
  return (
    <div className={`dropdown w-full ${active && "is-active"}`}>
      <div className="dropdown-trigger w-full">
        <div className={`control ${loading && "is-loading"}`}>
          <div className="field has-addons">
            <div className="control w-full">
              <input
                className="input"
                aria-haspopup="true"
                aria-controls="dropdown-menu"
                onChange={onChange}
                value={value}
                placeholder={placeholder}
                onKeyDown={onKeyDown}
                disabled={!disabled}
              />
            </div>
            <div className={`control ${disabled && "is-hidden"}`}>
              <button className="button is-danger" onClick={onClear}>
                Clear
              </button>
            </div>
          </div>
        </div>
      </div>
      <div className="dropdown-menu w-full" id="dropdown-menu" role="menu">
        <div className="dropdown-content">{children}</div>
      </div>
    </div>
  )
}
