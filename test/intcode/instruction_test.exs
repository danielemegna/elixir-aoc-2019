defmodule Intcode.InstructionTest do
  use ExUnit.Case
  alias Intcode.Instruction

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
    %Intcode.InstructionCode{
      opcode: opcode,
      first_parameter_mode: first,
      second_parameter_mode: second,
      third_parameter_mode: third
    }
  end

end
