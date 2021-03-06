import { errorFlashStateVar } from "$/cache"
import { useReactiveVar } from "@apollo/client"
import React, { useEffect } from "react"

export default function ErrorMessage() {
  const errorState = useReactiveVar(errorFlashStateVar)
  const message = errorState.message
  const clearMessage = () => {
    errorFlashStateVar({ consumed: true, message: "" })
  }
  const consumeMessage = () => {
    errorFlashStateVar({ consumed: true })
  }
  useEffect(consumeMessage, [])
  if (!message || errorState.consumed) {
    return <></>
  }
  return (
    <article className="message is-danger">
      <div className="message-header">
        <p>Error</p>
        <button className="delete" aria-label="delete" onClick={clearMessage} />
      </div>
      <div className="message-body">{message}</div>
    </article>
  )
}
