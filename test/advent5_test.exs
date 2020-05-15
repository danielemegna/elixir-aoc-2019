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

  test "introduce get input operation (opcode 3)" do
    run_program_test_with_input([3,5,99,123,123,123], 987, [3,5,99,123,123,987]) # (put 987 in position 5)
  end

  test "introduce output operation (opcode 4)" do
    run_program_test_with_expected_output([4,5,99,123,123,46], [4,5,99,123,123,46], [46]) # (output 46 from position 5)
    run_program_test_with_expected_output([104,46,99,123,123,123], [104,46,99,123,123,123], [46]) # (output 46 immediate mode)
  end

  test "resolve level" do
    result = Advent5.resolve
    assert result == [0, 0, 0, 0, 0, 0, 0, 0, 0, 3122865]
  end

  defp run_program_test(initial_memory, expected_final_memory) do
    run_program_test(initial_memory, 42, expected_final_memory, [])
  end

  defp run_program_test_with_expected_output(initial_memory, expected_final_memory, expected_outputs) do
    run_program_test(initial_memory, 42, expected_final_memory, expected_outputs)
  end

  defp run_program_test_with_input(initial_memory, input, expected_final_memory) do
    run_program_test(initial_memory, input, expected_final_memory, [])
  end

  defp run_program_test(initial_memory, input, expected_final_memory, expected_outputs) do
    { final_memory, outputs } = Advent5.run_memory_program_from_instruction(initial_memory, 0, input, [])
    assert final_memory == expected_final_memory
    assert outputs == expected_outputs
  end

end

defmodule InstructionCodeTest do
  use ExUnit.Case

  test "build InstructionCode from code" do
    assert InstructionCode.build_from(1) == instruction_code_with(1, 0, 0, 0)
    assert InstructionCode.build_from(2) == instruction_code_with(2, 0, 0, 0)
    assert InstructionCode.build_from(1101) == instruction_code_with(1, 1, 1, 0)
    assert InstructionCode.build_from(1102) == instruction_code_with(2, 1, 1, 0)
    assert InstructionCode.build_from(1001) == instruction_code_with(1, 0, 1, 0)
    assert InstructionCode.build_from(11101) == instruction_code_with(1, 1, 1, 1)
    assert InstructionCode.build_from(10002) == instruction_code_with(2, 0, 0, 1)
    assert InstructionCode.build_from(102) == instruction_code_with(2, 1, 0, 0)
    assert InstructionCode.build_from(99) == instruction_code_with(99, 0, 0, 0)
    assert InstructionCode.build_from(3) == instruction_code_with(3, 0, 0, 0)
  end

  defp instruction_code_with(opcode, first, second, third) do
    %InstructionCode{
      opcode: opcode,
      first_parameter_mode: first,
      second_parameter_mode: second,
      third_parameter_mode: third
    }
  end

end

defmodule InstructionTest do
  use ExUnit.Case

  test "length is estabilished from opcode" do
    any_pointer = 0
    assert 4 == Instruction.build_from(1, any_pointer).length
    assert 4 == Instruction.build_from(1102, any_pointer).length
    assert 2 == Instruction.build_from(3, any_pointer).length
    assert 2 == Instruction.build_from(10004, any_pointer).length
    assert 1 == Instruction.build_from(99, any_pointer).length
  end

  test "get parameters from memory for operation in position mode" do
    memory = [0, 5, 4, 3, 99, 123]
    instruction = %Instruction{
      code: instruction_code_with(1,0,0,0),
      memory_pointer: 0,
      length: 4
    }

    assert 123 == Instruction.first_parameter_from(instruction, memory)
    assert 99 == Instruction.second_parameter_from(instruction, memory)
    assert 3 == Instruction.third_parameter_from(instruction, memory)
  end

  test "get parameters from memory for operation in immediate mode" do
    memory = [0, 5, 4, 3, 99, 123]
    instruction = %Instruction{
      code: instruction_code_with(2,1,1,1),
      memory_pointer: 0,
      length: 4
    }

    assert 5 == Instruction.first_parameter_from(instruction, memory)
    assert 4 == Instruction.second_parameter_from(instruction, memory)
    assert 3 == Instruction.third_parameter_from(instruction, memory)
  end

  test "get parameters in mixed modes" do
    memory = [0, 5, 4, 3, 99, 123]
    instruction = %Instruction{
      code: instruction_code_with(1,1,0,0),
      memory_pointer: 0,
      length: 4
    }

    assert 5 == Instruction.first_parameter_from(instruction, memory)
    assert 99 == Instruction.second_parameter_from(instruction, memory)
    assert 3 == Instruction.third_parameter_from(instruction, memory)
  end

  defp instruction_code_with(opcode, first, second, third) do
    %InstructionCode{
      opcode: opcode,
      first_parameter_mode: first,
      second_parameter_mode: second,
      third_parameter_mode: third
    }
  end

end
