defmodule EmployeeRewardAppWeb.PageControllerTest do
  use EmployeeRewardAppWeb.ConnCase

  test "GET / has an element with id 'root'", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "id=\"root\""
  end
end
