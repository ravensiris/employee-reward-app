import BalanceSummary from "$/components/BalanceSummary";
import Hello from "$components/Hello";
import Navbar from "$components/Navbar";

export default function Home() {
  return (
    <>
      <Navbar></Navbar>
      <Hello />
      <BalanceSummary />
    </>
  );
}
