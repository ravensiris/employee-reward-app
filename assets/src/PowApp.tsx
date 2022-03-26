import Register from "$pages/Register"
import SignIn from "$pages/SignIn"
import React from "react"
import { Navigate, Route, Routes } from "react-router-dom"

function PowApp() {
  return (
    <Routes>
      <Route path="/session/new" element={<SignIn />} />
      <Route path="/registration/new" element={<Register />} />

      <Route
        path="/registration"
        element={<Navigate to="/registration/new" />}
      />
      <Route path="/session" element={<Navigate to="/session/new" />} />
    </Routes>
  )
}

export default PowApp
