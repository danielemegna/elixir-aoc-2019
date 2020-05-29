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
    run_program_test([3,5,99,123,123,123], 987, [3,5,99,123,123,987], []) # (put 987 in position 5)
  end

  test "consume multiple inputs (opcode 3)" do
    # (put 19 in position 5 and put 46 in position 4)
    run_program_test([3,7,3,6,99,123,123,123], [19,46], [3,7,3,6,99,123,46,19], [])
  end

  test "introduce output operation (opcode 4)" do
    run_program_test([4,5,99,123,123,46], [], [4,5,99,123,123,46], [46]) # (output 46 from position 5)
    run_program_test([104,46,99,123,123,123], [], [104,46,99,123,123,123], [46]) # (output 46 immediate mode)
  end

  test "resolve level (first part)" do
    result = Advent5.resolve_first_part
    assert result == [0,0,0,0,0,0,0,0,0,3122865]
  end

  test "introduce 'jump if true' operation (opcode 5)" do
   # input 0 --> output 0
    run_program_test(
      [3,3,1105,-1,9,1101,0,0,12,4,12,99,1], 0,
      [3,3,1105,0,9,1101,0,0,12,4,12,99,0], [0]
    )
   # input not 0 --> output 1
    run_program_test(
      [3,3,1105,-1,9,1101,0,0,12,4,12,99,1], 19,
      [3,3,1105,19,9,1101,0,0,12,4,12,99,1], [1]
    )
  end

  test "introduce 'jump if false' operation (opcode 6)" do
   # input 0 --> output 0
    run_program_test(
      [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], 0,
      [3,12,6,12,15,1,13,14,13,4,13,99,0,0,1,9], [0]
    )
   # input not 0 --> output 1
    run_program_test(
      [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], 19,
      [3,12,6,12,15,1,13,14,13,4,13,99,19,1,1,9], [1]
    )
  end

  test "introduce 'less than' operation (opcode 7)" do
    # position mode
    run_program_test([3,9,7,9,10,9,4,9,99,-1,8], 7, [3,9,7,9,10,9,4,9,99,1,8], [1]) # input is less than 8 --> output 1
    run_program_test([3,9,7,9,10,9,4,9,99,-1,8], 8, [3,9,7,9,10,9,4,9,99,0,8], [0]) # input is not less than 8 --> output 0
    run_program_test([3,9,7,9,10,9,4,9,99,-1,8], 9, [3,9,7,9,10,9,4,9,99,0,8], [0]) # input is not less than 8 --> output 0
    # immediate mode
    run_program_test([3,3,1107,-1,8,3,4,3,99], 7, [3,3,1107,1,8,3,4,3,99], [1]) # input is less than 8 --> output 1
    run_program_test([3,3,1107,-1,8,3,4,3,99], 9, [3,3,1107,0,8,3,4,3,99], [0]) # input is not less than 8 --> output 0
  end

  test "introduce equals operation (opcode 8)" do
    # position mode
    run_program_test([3,9,8,9,10,9,4,9,99,-1,19], 19, [3,9,8,9,10,9,4,9,99,1,19], [1]) # input is equal to 19 --> output 1
    run_program_test([3,9,8,9,10,9,4,9,99,-1,19], 6, [3,9,8,9,10,9,4,9,99,0,19], [0]) # input is not equal to 19 --> output 0
    # immediate mode
    run_program_test([3,3,1108,-1,19,3,4,3,99], 19, [3,3,1108,1,19,3,4,3,99], [1]) # input is equal to 19 --> output 1
    run_program_test([3,3,1108,-1,19,3,4,3,99], 6, [3,3,1108,0,19,3,4,3,99], [0]) # input is not equal to 19 --> output 0
  end

  test "final test for second part" do
    memory = [
      3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
      1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
      999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
    ]

    run_program_test(memory, 7, :any, [999]) # output 999 if the input value is below 8
    run_program_test(memory, 8, :any, [1000]) # output 1000 if the input value is equal to 8
    run_program_test(memory, 9, :any, [1001]) # output 1001 if the input value is greater than 8.
  end

  test "resolve level (second part)" do
    result = Advent5.resolve_second_part
    assert result == [773660]
  end

  test "halts on halt operation (99)" do
    memory = [3,3,1101,-1,4,5,4,5,99,:ignored,:ignored]
    { final_memory, last_instruction, outputs } = Advent5.run_memory_program(memory, [42])
    assert final_memory == [3,3,1101,42,4,46,4,5,99,:ignored,:ignored]
    assert outputs == [46]
    assert last_instruction.code.opcode == :halt
  end

  test "halts on read operation (3) without enough input provided" do
    memory = [3,3,1101,-1,4,5,4,5,3,:ignored,:ignored]
    { final_memory, last_instruction, outputs } = Advent5.run_memory_program(memory, [42])
    assert final_memory == [3,3,1101,42,4,46,4,5,3,:ignored,:ignored]
    assert outputs == [46]
    assert last_instruction.code.opcode == :read
  end

  defp run_program_test(initial_memory, expected_final_memory) do
    run_program_test(initial_memory, [], expected_final_memory, [])
  end

  defp run_program_test(initial_memory, inputs_stack, expected_final_memory, expected_outputs) when is_list(inputs_stack) do
    { final_memory, last_instruction, outputs } = Advent5.run_memory_program(initial_memory, inputs_stack)
    if(expected_outputs != :any) do
      assert outputs == expected_outputs
    end
    if(expected_final_memory != :any) do
      assert final_memory == expected_final_memory
    end
    assert last_instruction.code.opcode == :halt
  end

  defp run_program_test(initial_memory, input_value, expected_final_memory, expected_outputs) do
    run_program_test(initial_memory, [input_value], expected_final_memory, expected_outputs)
  end

end

defmodule InstructionCodeTest do
  use ExUnit.Case

  test "build InstructionCode from code" do
    assert InstructionCode.build_from(1) == instruction_code_with(:add, :position, :position, :position)
    assert InstructionCode.build_from(2) == instruction_code_with(:mult, :position, :position, :position)
    assert InstructionCode.build_from(1101) == instruction_code_with(:add, :immediate, :immediate, :position)
    assert InstructionCode.build_from(1102) == instruction_code_with(:mult, :immediate, :immediate, :position)
    assert InstructionCode.build_from(1001) == instruction_code_with(:add, :position, :immediate, :position)
    assert InstructionCode.build_from(11101) == instruction_code_with(:add, :immediate, :immediate, :immediate)
    assert InstructionCode.build_from(10002) == instruction_code_with(:mult, :position, :position, :immediate)
    assert InstructionCode.build_from(102) == instruction_code_with(:mult, :immediate, :position, :position)
    assert InstructionCode.build_from(99) == instruction_code_with(:halt, :position, :position, :position)
    assert InstructionCode.build_from(3) == instruction_code_with(:read, :position, :position, :position)
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
      code: instruction_code_with(:add,:position,:position,:position),
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
      code: instruction_code_with(:mult,:immediate,:immediate,:immediate),
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
      code: instruction_code_with(:add,:immediate,:position,:position),
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
