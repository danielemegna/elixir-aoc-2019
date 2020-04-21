defmodule Advent2Test do
  use ExUnit.Case

  test "run_memory_program function test" do
    assert Advent2.run_memory_program([1,0,0,0,99]) == [2,0,0,0,99] # (1 + 1 = 2)
    assert Advent2.run_memory_program([2,3,0,3,99]) == [2,3,0,6,99] # (3 * 2 = 6)
    assert Advent2.run_memory_program([2,4,4,5,99,0]) == [2,4,4,5,99,9801] # 99 * 99 = 9801
    assert Advent2.run_memory_program([1,9,10,3,2,3,11,0,99,30,40,50]) == [3500,9,10,70,2,3,11,0,99,30,40,50]
    assert Advent2.run_memory_program([1,1,1,4,99,5,6,0,99]) == [30,1,1,4,2,5,6,0,99]
  end

  test "resolve level (first part)" do
    result = Advent2.resolve_first_part
    assert Enum.at(result, 0) == 2894520
  end

end
