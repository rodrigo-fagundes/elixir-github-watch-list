defmodule ElixirGithubWatchListWeb.PageController do
  use ElixirGithubWatchListWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
