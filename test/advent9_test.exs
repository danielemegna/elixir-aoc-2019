defmodule Advent9Test do
  use ExUnit.Case

  test "resolve level (first part)" do
    assert [3460311188] === Advent9.resolve_first_part
  end

  test "resolve level (second part)" do
    assert [42202] === Advent9.resolve_second_part
  end

end
