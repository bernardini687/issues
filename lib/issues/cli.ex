defmodule Issues.CLI do
  @moduledoc """
  handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last `n` issues in a github repository
  """

  @default_count 4

  def run(argv) do
    argv
    |> parse_argv()
    |> process()
  end

  @doc """
  `argv` can hold -h or --help, which returns `:help`

  otherwise it is a github user name, repository name, and an optional
  number of entries to format, which returns `{user, repository, count}`
  """
  def parse_argv(argv) do
    parse = OptionParser.parse(
      argv,
      alias: [h: :help],
      strict: [help: :boolean]
    )

    case parse do
      {[help: true], _, _}
        -> :help

      {_, [user, repo, count], _}
        -> {user, repo, String.to_integer(count)}

      {_, [user, repo], _}
        -> {user, repo, @default_count}

      _ -> :help
    end
  end

  @doc """
  process the parsed argv
  """
  def process(:help) do
    IO.puts("usage: issues <user> <project> [count | #{@default_count}]")
    System.halt(0)
  end

  def process({user, repo, _count}) do
    Issues.GitHubIssues.fetch(user, repo)
    |> decode_response()
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, details}) do
    IO.puts("error along fetching process: `#{details}`")
    System.halt(2)
  end
end
