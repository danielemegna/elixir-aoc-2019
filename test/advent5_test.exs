defmodule Advent5Test do
  use ExUnit.Case

  test "resolve level (first part)" do
    result = Advent5.resolve_first_part
    assert result == [0,0,0,0,0,0,0,0,0,3122865]
  end

  test "resolve level (second part)" do
    result = Advent5.resolve_second_part
    assert result == [773660]
  end

end
