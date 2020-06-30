defmodule Intcode.InstructionCode do
  alias __MODULE__

  @enforce_keys [:opcode, :first_parameter_mode, :second_parameter_mode, :third_parameter_mode]
  defstruct @enforce_keys

  def build_from(instruction_code_from_memory) do
    opcode = rem(instruction_code_from_memory, 100)
    first_parameter_mode = rem(div(instruction_code_from_memory, 100), 10)
    second_parameter_mode = rem(div(instruction_code_from_memory, 1000), 10)
    third_parameter_mode = div(instruction_code_from_memory, 10000)
    %InstructionCode{
      opcode: opcode_to_atom(opcode),
      first_parameter_mode: parameter_mode_to_atom(first_parameter_mode),
      second_parameter_mode: parameter_mode_to_atom(second_parameter_mode),
      third_parameter_mode: parameter_mode_to_atom(third_parameter_mode)
    }
  end

  defp opcode_to_atom(opcode) do
    case (opcode) do
      1 -> :add
      2 -> :mult
      3 -> :read
      4 -> :write
      5 -> :jump_if_true
      6 -> :jump_if_false
      7 -> :less_than
      8 -> :equals
      9 -> :adj_relative_base
      99 -> :halt
    end
  end

  defp parameter_mode_to_atom(parameter_mode) do
    case (parameter_mode) do
      0 -> :position
      1 -> :immediate
      2 -> :relative
    end
  end

end
