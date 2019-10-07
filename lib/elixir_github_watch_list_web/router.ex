defmodule ElixirGithubWatchListWeb.Router do
  use ElixirGithubWatchListWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixirGithubWatchListWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/:user", PageController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirGithubWatchListWeb do
  #   pipe_through :api
  # end
end
