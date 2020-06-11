defmodule Intcode.InstructionCodeTest do
  use ExUnit.Case
  alias Intcode.InstructionCode

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
