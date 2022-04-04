import AuthorizedRoute from "$components/AuthorizedRoute"
import Home from "$pages/Home"
import Register from "$pages/Register"
import Send from "$pages/Send"
import SignIn from "$pages/SignIn"
import { UserRole } from "$queries/user"
import React from "react"
import { Route, Routes } from "react-router-dom"
import AdminOverview from "./pages/AdminOverview"

function App() {
  return (
    <Routes>
      <Route
        path="/"
        element={
          <AuthorizedRoute>
            <Home />
          </AuthorizedRoute>
        }
      />
      <Route
        path="/send"
        element={
          <AuthorizedRoute>
            <Send />
          </AuthorizedRoute>
        }
      />
      <Route
        path="/admin/overview"
        element={
          <AuthorizedRoute role={UserRole.ADMIN}>
            <AdminOverview />
          </AuthorizedRoute>
        }
      />
      <Route path="/registration" element={<Register />} />
      <Route path="/registration/new" element={<Register />} />
      <Route path="/session" element={<SignIn />} />
      <Route path="/session/new" element={<SignIn />} />
    </Routes>
  )
}

export default App
