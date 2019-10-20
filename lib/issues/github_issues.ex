defmodule Issues.GitHubIssues do
  @user_agent [{"User-Agent", "bernardini687/issues"}]

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response()
  end

  def issues_url(user, project) do
    "https://api.github.com/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{body: body}}) do
    case Jason.decode(body) do
      {:ok, body}
        -> {:ok, body}

      {:error, details}
        -> {:error, "Jason failed to compile `#{details.data}`"}
    end
  end

  def handle_response({:error, %{reason: reason}}) do
    {:error, reason}
  end
end
