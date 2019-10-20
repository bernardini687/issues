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

  def handle_response(%{status_code: 200, body: body}), do: { :ok, body }
  def handle_response(%{status_code: _, body: body}), do: { :error, body }
end
