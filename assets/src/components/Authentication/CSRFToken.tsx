import React from "react"

/**
 * Placeholder for a CSRF token that is supposed to be hydrated in.
 */
export default function CSRFToken() {
  return <input name="_csrf_token" type="hidden" />
}
