import {
  Buttons,
  CSRFToken,
  ErrorMessage,
  Input,
  Title,
} from "$components/Authentication";

export default function SignIn() {
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
