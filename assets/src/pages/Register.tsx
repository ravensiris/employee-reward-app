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
      <Title>Register</Title>
      <form method="post" className="section">
        <CSRFToken />
        <ErrorMessage />
        <Input>Email</Input>
        <Input>Password</Input>
        <Input>Confirm password</Input>
        <Buttons />
      </form>
    </>
  );
}
