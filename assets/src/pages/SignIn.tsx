import {
  Buttons,
  CSRFToken,
  ErrorMessage,
  Input,
  Title,
} from "$components/Authentication";
import { useEffect, useState } from "react";

export default function SignIn() {
  const [isClient, setClient] = useState(false);
  useEffect(() => {
    setClient(true);
  }, []);
  return (
    <>
      <Title>Sign in</Title>
      <form method="post" className="section">
        <CSRFToken />
        <ErrorMessage />
        <Input>Email</Input>
        <Input>Password</Input>
        <Buttons />
      </form>
    </>
  );
}
