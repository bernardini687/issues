defmodule CliTest do
  use ExUnit.Case

  import Issues.CLI, only: [parse_argv: 1]

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
end
