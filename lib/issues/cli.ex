defmodule Issues.CLI do
  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last `n` issues in a github repository.
  """

  import Issues.TableFormatter, only: [print_table_for_columns: 2]

  @default_count 4
  @headers ~w(number created_at title)a

  def main(argv) do
    argv
    |> parse_argv()
    |> process()
  end

  @doc """
  `argv` can hold -h or --help, which returns `:help`.

  Otherwise it is a github user name, repository name, and an optional
  number of entries to format, which returns `{user, repository, count}`.
  """
  def parse_argv(argv) do
    parse =
      OptionParser.parse(
        argv,
        alias: [h: :help],
        strict: [help: :boolean]
      )

    case parse do
      {[help: true], _, _} ->
        :help

      {_, [user, repo, count], _} ->
        {user, repo, String.to_integer(count)}

      {_, [user, repo], _} ->
        {user, repo, @default_count}

      _ ->
        :help
    end
  end

  def process(:help) do
    IO.puts("usage: issues <user> <project> [count | #{@default_count}]")
    System.halt(0)
  end

  def process({user, repo, count}) do
    Issues.GitHubIssues.fetch(user, repo)
    |> decode_response()
    |> sort_by_ascending_order()
    |> Enum.take(count)
    |> print_table_for_columns(@headers)
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, details}) do
    IO.puts("error along fetching process: `#{details}`")
    System.halt(2)
  end

  def sort_by_ascending_order(issues) do
    Enum.sort(issues, &(&1[:created_at] <= &2[:created_at]))
  end
end
