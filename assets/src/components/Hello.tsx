import { useMe } from "$queries/user"
import React from "react"

export default function Hello() {
  const { loading, data } = useMe()
  const name = data?.me.name || data?.me.email || undefined
  return (
    <section className="section hero is-primary">
      <div className="hero-body">
        <p className={`title ${loading && "loading"}`}>Hello,</p>
        <p className={`subtitle ${loading && "loading"}`}>{name}</p>
      </div>
    </section>
  )
}
