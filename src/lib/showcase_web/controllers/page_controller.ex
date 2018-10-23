defmodule ShowcaseWeb.PageController do
  use ShowcaseWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
