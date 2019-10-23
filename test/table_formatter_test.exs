defmodule TableFormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Issues.TableFormatter, as: TF

  def sample_data do
    [
      [c1: "r1_c1", c2: "r1_c2", c3: "r1_c3", c4: "r1___c4"],
      [c1: "r2_c1", c2: "r2_c2", c3: "r2_c3", c4: "r2_c4"],
      [c1: "r3_c1", c2: "r3_c2", c3: "r3_c3", c4: "r3_c4"],
      [c1: "r4_c1", c2: "r4__c2", c3: "r4_c3", c4: "r4_c4"]
    ]
  end

  def headers, do: [:c1, :c2, :c4]

  def split_in_three_columns, do: TF.split_into_column(sample_data(), headers())

  test "TableFormatter.split_into_column/2" do
    columns = split_in_three_columns()

    assert length(columns) == length(headers())
    assert List.first(columns) == ~w(r1_c1 r2_c1 r3_c1 r4_c1)
    assert List.last(columns) == ~w(r1___c4 r2_c4 r3_c4 r4_c4)
  end

  test "TableFormatter.widths_of/1" do
    widths = TF.widths_of(split_in_three_columns())

    assert widths == [5, 6, 7]
  end

  test "returns formatted string" do
    assert TF.format_for([9, 10, 11]) == "~-9s | ~-10s | ~-11s~n"
  end

  test "correct output" do
    result =
      capture_io(fn -> TF.print_table_for_columns(sample_data(), headers()) end)

    assert result == """
    c1    | c2     | c4
    ------+--------+--------
    r1_c1 | r1_c2  | r1___c4
    r2_c1 | r2_c2  | r2_c4
    r3_c1 | r3_c2  | r3_c4
    r4_c1 | r4__c2 | r4_c4
    """
  end
end
