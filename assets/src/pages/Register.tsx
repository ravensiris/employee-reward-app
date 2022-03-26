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
      <Title>Register</Title>
      <form method="post" className="section" suppressHydrationWarning>
        <CSRFToken />
        <ErrorMessage />
        <Input>Email</Input>
        <Input>Name</Input>
        <Input>Password</Input>
        <Input>Confirm password</Input>
        <div className="field is-grouped is-grouped-multiline is-grouped-centered">
          <Submit>Register</Submit>
          <Button>Sign in</Button>
        </div>
        <div className="field is-grouped is-grouped-multiline is-grouped-centered">
          <PowAssentButtons />
        </div>
      </form>
    </>
  )
}
