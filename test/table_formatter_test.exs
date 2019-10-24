defmodule TableFormatterTest do
  use ExUnit.Case

  import ExUnit.CaptureIO, only: [capture_io: 1]

  alias Issues.TableFormatter, as: Table

  @sample_data [
    [c1: "r1_c1", c2: "r1_c2", c3: "r1_c3", c4: "r1___c4"],
    [c1: "r2_c1", c2: "r2_c2", c3: "r2_c3", c4: "r2_c4"],
    [c1: "r3_c1", c2: "r3_c2", c3: "r3_c3", c4: "r3_c4"],
    [c1: "r4_c1", c2: "r4__c2", c3: "r4_c3", c4: "r4_c4"]
  ]

  @headers ~w(c1 c2 c4)a

  def split_in_three_columns, do: Table.split_into_columns(@sample_data, @headers)

  test "TableFormatter.split_into_columns/2" do
    columns = split_in_three_columns()

    assert length(columns) == length(@headers)
    assert List.first(columns) == ~w(r1_c1 r2_c1 r3_c1 r4_c1)
    assert List.last(columns) == ~w(r1___c4 r2_c4 r3_c4 r4_c4)
  end

  test "TableFormatter.widths_of/1" do
    widths = Table.widths_of(split_in_three_columns())

    assert widths == [5, 6, 7]
  end

  test "returns formatted string" do
    assert Table.format_for([9, 10, 11]) == "~-9s | ~-10s | ~-11s~n"
  end

  test "correct output" do
    output = capture_io(fn -> Table.print_table_for_columns(@sample_data, @headers) end)

    assert output == """
           c1    | c2     | c4\s\s\s\s\s
           ------+--------+--------
           r1_c1 | r1_c2  | r1___c4
           r2_c1 | r2_c2  | r2_c4\s\s
           r3_c1 | r3_c2  | r3_c4\s\s
           r4_c1 | r4__c2 | r4_c4\s\s
           """
  end
end
