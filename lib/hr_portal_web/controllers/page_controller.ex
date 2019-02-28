defmodule HrPortalWeb.PageController do
  use HrPortalWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
