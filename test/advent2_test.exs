defmodule Advent2Test do
  use ExUnit.Case

  test "resolve level (first part)" do
    result = Advent2.resolve_first_part
    assert result == 2894520
  end

  test "resolve level (second part)" do
    result = Advent2.resolve_second_part
    assert result == 9342
  end

end
