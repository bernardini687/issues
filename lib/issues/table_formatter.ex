defmodule Issues.TableFormatter do
  @moduledoc """
  Handles the drawing of a table that displays the fetched data.
  """

  import Enum, only: [each: 2, map: 2, map_join: 3, max: 1]

  @doc """
  Takes a list of row data, where each row is a HashDict, and a list of
  headers. Prints a table to STDOUT of the data from each row
  identified by each header. That is, each header identifies a column,
  and those columns are extracted and printed from the rows.
  We calculate the width of each column to fit the longest element
  in that column.
  """
  def print_table_for_columns(rows, headers) do
    data_by_columns = split_into_columns(rows, headers)
    column_widths = widths_of(data_by_columns)
    format = format_for(column_widths)

    puts_one_line_in_columns(headers, format)
    IO.puts(separator(column_widths))
    puts_in_columns(data_by_columns, format)
  end

  @doc """
  Given a list of rows, where each row contains a keyed list
  of columns, return a list containing lists of the data in
  each column. The `headers` parameter contains the
  list of columns to extract.

  ## Example

      iex> [
      ...>   Enum.into([{a: 1}, {b: 2}, {c: 3}], HashDict.new),
      ...>   Enum.into([{a: 4}, {b: 5}, {c: 6}], HashDict.new)
      ...> ]
      ...> |> Issues.TableFormatter.split_into_columns([:b, :c])
      [["2", "5"], ["3", "6"]]
  """
  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: printable(row[header])
    end
  end

  @doc """
  Given a list containing sublists, where each sublist contains the data for
  a column, return a list containing the maximum width of each column.

  ## Example

      iex> data = [~w(cat wombat tiger), ~w(mongoose ant dragon)]
      iex> Issues.TableFormatter.widths_of(data)
      [6, 8]
  """
  def widths_of(columns) do
    for column <- columns, do: column |> map(&String.length/1) |> max()
  end

  @doc """
  Return a format string that hard codes the widths of a set of columns.
  We put ` | ` between each column.

  ## Example

      iex> widths = [5, 6, 99]
      iex> Issues.TableFormatter.format_for(widths)
      "~-5s | ~-6s | ~-99s~n"
  """
  def format_for(column_widths) do
    map_join(column_widths, " | ", &"~-#{&1}s") <> "~n"
  end

  @doc """
  Return a binary (string) version of the given parameter.

  ## Example

      iex> Issues.TableFormatter.printable("a")
      "a"
      iex> Issues.TableFormatter.printable(99)
      "99"
  """
  defp printable(string) when is_binary(string), do: string
  defp printable(string), do: to_string(string)

  @doc """
  Generate the line that goes below the column headings. It is a string of
  hyphens, with `+` signs where the vertical bar between the columns goes.

  ## Example

      iex> widths = [5, 6, 9]
      iex> Issues.TableFormatter.separator(widths)
      "------+--------+----------"
  """
  defp separator(column_widths) do
    map_join(column_widths, "-+-", &List.duplicate("-", &1))
  end

  defp puts_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip()
    |> map(&Tuple.to_list/1)
    |> each(&puts_one_line_in_columns(&1, format))
  end

  defp puts_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end
end
