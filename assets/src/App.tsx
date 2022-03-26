import Home from "$pages/Home"
import Register from "$pages/Register"
import Send from "$pages/Send"
import SignIn from "$pages/SignIn"
import React from "react"
import { Route, Routes } from "react-router-dom"

function App() {
  return (
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/send" element={<Send />} />
      <Route path="/registration" element={<Register />} />
      <Route path="/registration/new" element={<Register />} />
      <Route path="/session" element={<SignIn />} />
      <Route path="/session/new" element={<SignIn />} />
    </Routes>
  )
}

export default App
