defmodule Issues.GitHubIssues do
  @moduledoc """
  Handles the request to the GitHub API.
  """

  @github_url Application.get_env(:issues, :github_url)
  @user_agent [{"User-Agent", "bernardini687/issues"}]

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response()
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{body: body}}) do
    case Jason.decode(body, keys: :atoms) do
      {:ok, body}
        -> {:ok, body}

      {:error, details}
        -> {:error, "Jason failed to compile `#{details.data}`"}
    end
  end

  def handle_response({:error, %{reason: details}}) do
    {:error, details}
  end
end
