import Home from "$pages/Home";
import SignIn from "$pages/SignIn";
import { Route, Routes } from "react-router-dom";

function App() {
  return (
    <>
      <Routes>
        <Route path="/" element={<Home />}></Route>
        <Route path="/session" element={<SignIn />}></Route>
        <Route path="/session/new" element={<SignIn />}></Route>
      </Routes>
    </>
  );
}

export default App;
