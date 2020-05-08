defmodule Advent5Test do
  use ExUnit.Case

  test "retrocompatibility tests" do
    run_program_test([1,0,0,0,99], [2,0,0,0,99]) # (1 + 1 = 2)
    run_program_test([2,3,0,3,99], [2,3,0,6,99]) # (3 * 2 = 6)
    run_program_test([2,4,4,5,99,0], [2,4,4,5,99,9801]) # 99 * 99 = 9801
    run_program_test([1,9,10,3,2,3,11,0,99,30,40,50], [3500,9,10,70,2,3,11,0,99,30,40,50])
    run_program_test([1,1,1,4,99,5,6,0,99], [30,1,1,4,2,5,6,0,99])
  end

  test "introduce immediate parameter mode" do
    run_program_test([1101,2,3,3,99], [1101,2,3,5,99]) # (2 + 3 = 5)
    run_program_test([1102,2,3,3,99], [1102,2,3,6,99]) # (2 * 3 = 6)
    run_program_test([1001,4,1,0,99], [100,4,1,0,99]) # (99 + 1 = 100)
    run_program_test([101,1,4,0,99], [100,1,4,0,99]) # (1 + 99 = 100)
  end

  @tag :skip
  test "resolve level" do
    result = Advent5.resolve
    assert result == 2894520
  end

  defp run_program_test(initial_memory, expected_final_memory) do
    run_program_test(initial_memory, [], expected_final_memory)
  end

  defp run_program_test(initial_memory, inputs, expected_final_memory) do
    final_memory = Advent5.run_memory_program_from_instruction(initial_memory, 0, inputs)
    assert final_memory == expected_final_memory
  end

end

defmodule InstructionCodeTest do
  use ExUnit.Case

  test "build InstructionCode from code" do
    assert InstructionCode.build_from(1) == instruction_with(1, 0, 0, 0)
    assert InstructionCode.build_from(2) == instruction_with(2, 0, 0, 0)
    assert InstructionCode.build_from(1101) == instruction_with(1, 1, 1, 0)
    assert InstructionCode.build_from(1102) == instruction_with(2, 1, 1, 0)
    assert InstructionCode.build_from(1001) == instruction_with(1, 0, 1, 0)
    assert InstructionCode.build_from(11101) == instruction_with(1, 1, 1, 1)
    assert InstructionCode.build_from(10002) == instruction_with(2, 0, 0, 1)
    assert InstructionCode.build_from(102) == instruction_with(2, 1, 0, 0)
    assert InstructionCode.build_from(99) == instruction_with(99, 0, 0, 0)
  end

  defp instruction_with(opcode, first, second, third) do
    %InstructionCode{
      opcode: opcode,
      first_parameter_mode: first,
      second_parameter_mode: second,
      third_parameter_mode: third
    }
  end

end
