defmodule EmployeeRewardAppWeb.PageControllerTest do
  use EmployeeRewardAppWeb.ConnCase

  test "GET / Unathorized redirect", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 302) =~ "You are being"
  end
end
