import type { FlashState } from "$/cache"
import { ReactiveVar } from "@apollo/client"
import React, { useEffect, useRef } from "react"

interface FlashProps {
  flashState: ReactiveVar<FlashState>
}

export default function Flash({ flashState }: FlashProps) {
  const messageElemRef = useRef<HTMLSpanElement>(null)
  useEffect(() => {
    if (messageElemRef.current && messageElemRef.current.innerText) {
      const message = messageElemRef.current.innerText
      flashState({ message, consumed: false })
    }
  }, [])
  return (
    <>
      <span
        id="message"
        ref={messageElemRef}
        dangerouslySetInnerHTML={{ __html: "" }}
      />
    </>
  )
}
