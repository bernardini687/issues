defmodule Issues.CLI do
  @moduledoc """
  handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last `n` issues in a github project
  """

  @default_count 4

  def run(argv) do
    parse_argv(argv)
  end

  @doc """
  `argv` can hold -h or --help, which returns `:help`

  otherwise it is a github user name, project name, and an optional
  number of entries to format, which returns `{user, project, count}`
  """
  def parse_argv(argv) do
    parse = OptionParser.parse(
      argv,
      alias: [h: :help],
      strict: [help: :boolean]
    )

    case parse do
      {[help: true], _, _} -> :help
      {_, [user, project, count], _} -> {user, project, count}
      {_, [user, project], _} -> {user, project, @default_count}
      _ -> :help
    end
  end
end
