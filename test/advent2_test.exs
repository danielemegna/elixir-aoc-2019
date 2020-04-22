defmodule Advent2Test do
  use ExUnit.Case

  test "run_memory_program_from_instruction function test" do
    run_program_test([1,0,0,0,99], [2,0,0,0,99]) # (1 + 1 = 2)
    run_program_test([2,3,0,3,99], [2,3,0,6,99]) # (3 * 2 = 6)
    run_program_test([2,4,4,5,99,0], [2,4,4,5,99,9801]) # 99 * 99 = 9801
    run_program_test([1,9,10,3,2,3,11,0,99,30,40,50], [3500,9,10,70,2,3,11,0,99,30,40,50])
    run_program_test([1,1,1,4,99,5,6,0,99], [30,1,1,4,2,5,6,0,99])
  end

  test "resolve level (first part)" do
    result = Advent2.resolve_first_part
    assert result == 2894520
  end

  test "resolve level (second part)" do
    result = Advent2.resolve_second_part
    assert result == 9342
  end

  defp run_program_test(initial_memory, expected_final_memory) do
    final_memory = Advent2.run_memory_program_from_instruction(initial_memory, 0)
    assert final_memory == expected_final_memory
  end

end
