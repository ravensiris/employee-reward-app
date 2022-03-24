import Home from "$pages/Home";
import Register from "$pages/Register";
import SignIn from "$pages/SignIn";
import { Route, Routes } from "react-router-dom";

function App() {
  return (
    <>
      <Routes>
        <Route path="/" element={<Home />}></Route>
        <Route path="/registration" element={<Register />}></Route>
        <Route path="/registration/new" element={<Register />}></Route>
        <Route path="/session" element={<SignIn />}></Route>
        <Route path="/session/new" element={<SignIn />}></Route>
      </Routes>
    </>
  );
}

export default App;
