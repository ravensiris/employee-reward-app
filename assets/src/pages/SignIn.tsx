import {
  Button,
  CSRFToken,
  ErrorMessage,
  Input,
  PowAssentButtons,
  Submit,
  Title,
} from "$components/Authentication"
import React from "react"

export default function SignIn() {
  return (
    <>
      <Title>Sign in</Title>
      <form method="post" className="section" suppressHydrationWarning>
        <CSRFToken />
        <ErrorMessage />
        <Input>Email</Input>
        <Input>Password</Input>
        <div className="field is-grouped is-grouped-multiline is-grouped-centered">
          <Submit>Sign in</Submit>
          <Button>Register</Button>
        </div>
        <div className="field is-grouped is-grouped-multiline is-grouped-centered">
          <PowAssentButtons />
        </div>
      </form>
    </>
  )
}
