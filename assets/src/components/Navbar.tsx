import { NavbarState, navbarStateVar } from "$/cache"
import { useReactiveVar } from "@apollo/client"
import React from "react"
import type { LinkProps } from "react-router-dom"
import { Link, useMatch, useResolvedPath } from "react-router-dom"

function NavLink({ children, to, ...props }: LinkProps) {
  const resolved = useResolvedPath(to)
  const match = useMatch({ path: resolved.pathname, end: true })
  return (
    <Link
      onClick={() => navbarStateVar({ hidden: true })}
      className={`navbar-item ${match && "is-active"}`}
      to={to}
      {...props}
    >
      {children}
    </Link>
  )
}

function NavBurger() {
  const navbarState = useReactiveVar<NavbarState>(navbarStateVar)
  const active = !navbarState.hidden
  const toggleHidden = () => navbarStateVar({ hidden: !navbarState.hidden })
  return (
    <a
      role="button"
      className={`navbar-burger ${active && "is-active"}`}
      aria-label="menu"
      aria-expanded="false"
      data-target="navbarMenu"
      onClick={toggleHidden}
    >
      <span aria-hidden="true"></span>
      <span aria-hidden="true"></span>
      <span aria-hidden="true"></span>
    </a>
  )
}

interface NavMenuProps {
  children?: React.ReactNode
}
function NavMenu({ children }: NavMenuProps) {
  const navbarState = useReactiveVar<NavbarState>(navbarStateVar)
  const active = !navbarState.hidden
  return (
    <div id="navbarMenu" className={`navbar-menu ${active && "is-active"}`}>
      <div className="navbar-start">{children}</div>
    </div>
  )
}

function Navbar() {
  return (
    <nav className="navbar" role="navigation" aria-label="main navigation">
      <div className="navbar-brand">
        <NavBurger />
      </div>
      <NavMenu>
        <NavLink to="/">Home</NavLink>
        <NavLink to="/send">Send</NavLink>
      </NavMenu>
    </nav>
  )
}

export default Navbar
