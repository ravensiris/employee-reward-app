import { useMe, UserRole } from "$queries/user"
import React from "react"
import { Navigate, useLocation } from "react-router-dom"

export interface Props {
  children?: React.ReactNode
  role?: UserRole
}

export default function AuthorizedRoute({ children, role }: Props) {
  const location = useLocation()
  const { data: meData, loading, error } = useMe()

  if (loading) {
    return <p>Waiting for authorization...</p>
  }

  if (error) {
    return <Navigate to="/session/new" state={{ from: location }} />
  }

  if (role !== undefined && meData?.me.role !== role) {
    return <Navigate to="/" state={{ from: location }} />
  }

  return <>{children}</>
}
