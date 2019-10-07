defmodule ElixirGithubWatchListWeb.PageController do
  use ElixirGithubWatchListWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", user: "", projects: %{})
  end

  def show(conn, %{"user" => user}) do
    # Preparing query and api key
    qry = "{ \"query\": \"query { user (login: \\\"#{user}\\\") { watching (first: 100) { totalCount, edges { node { id, name, url } } }, repositories { totalCount }, organizations { totalCount }, starredRepositories { totalCount }, contributionsCollection { totalCommitContributions, pullRequestContributions { totalCount } } } }\" }"
    apiKey = "token #{Application.get_env(:elixir_github_watch_list, ElixirGithubWatchListWeb.PageController)[:github_key]}"

    # Calling Github API
    case HTTPoison.post(
      "https://api.github.com/graphql",
      qry,
      %{ "Content-Type" => "application/json",
         "Authorization" => apiKey }
      ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        data = Jason.decode!(body)
        render(conn, "index.html", user: user, projects: data)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
        render(conn, "index.html", user: user)
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
        render(conn, "index.html", user: user)
    end
  end
end
