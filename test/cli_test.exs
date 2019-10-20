defmodule CLITest do
  use ExUnit.Case

  import Issues.CLI, only: [parse_argv: 1,
                            sort_by_ascending_order: 1,
                            process: 1]

  test "returns :help if given -h or --help options" do
    assert parse_argv(["-h", "foo"]) == :help
    assert parse_argv(["--help", "bar"]) == :help
  end

  test "returns three values if given three options" do
    assert parse_argv([?a, ?b, "3"]) == {?a, ?b, 3}
  end

  test "defaults count if given two options" do
    assert parse_argv([?a, ?b]) == {?a, ?b, 4}
  end

  test "sort_by_ascending_orders/1" do
    result =
      ~w[c b a]
      |> fake_created_at_list()
      |> sort_by_ascending_order()

    issues = for issue <- result, do: issue[:created_at]

    assert issues == ~w[a b c]
  end

  @tag :skip
  test "successful process" do
    issues = process({"christopheradams", "elixir_style_guide", 3})

    assert length(issues) == 3
  end

  defp fake_created_at_list(values) do
    for value <- values, do: [created_at: value, foo: "bar"]
  end
end
