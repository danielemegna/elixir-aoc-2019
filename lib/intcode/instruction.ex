defmodule Intcode.Instruction do
  alias __MODULE__

  @enforce_keys [:code, :memory_pointer, :relative_base, :length]
  defstruct @enforce_keys

  def build_from(instruction_code_from_memory, memory_pointer, relative_base) do
    instruction_code = Intcode.InstructionCode.build_from(instruction_code_from_memory)
    %Instruction{
      code: instruction_code,
      memory_pointer: memory_pointer,
      relative_base: relative_base,
      length: instruction_length_for(instruction_code.opcode)
    }
  end

  def first_parameter_from(%{code: %{opcode: :read}} = instruction, memory), do:
    get_address_where_write_for(instruction, memory, 1)

  def first_parameter_from(instruction, memory), do:
    get_parameter_value_for(instruction, memory, 1)

  def second_parameter_from(instruction, memory), do:
    get_parameter_value_for(instruction, memory, 2)

  def third_parameter_from(%{code: %{opcode: opcode}} = instruction, memory) when opcode in [:add, :mult, :less_than, :equals], do:
    get_address_where_write_for(instruction, memory, 3)

  def third_parameter_from(instruction, memory), do:
    get_parameter_value_for(instruction, memory, 3)

  defp instruction_length_for(opcode) when opcode in [:add, :mult, :less_than, :equals], do: 4
  defp instruction_length_for(opcode) when opcode in [:read, :write, :adj_relative_base], do: 2
  defp instruction_length_for(opcode) when opcode in [:jump_if_true, :jump_if_false], do: 3
  defp instruction_length_for(:halt), do: 1

  defp get_parameter_value_for(instruction, memory, parameter_offset) do
    parameter_mode = get_parameter_mode_for(instruction, parameter_offset)
    case(parameter_mode) do
      :immediate -> memory_at(memory, instruction.memory_pointer + parameter_offset)
      :position -> memory_at(memory, memory_at(memory, instruction.memory_pointer + parameter_offset))
      :relative -> memory_at(memory, memory_at(memory, instruction.memory_pointer + parameter_offset) + instruction.relative_base)
    end
  end

  # "Parameters that an instruction writes to will never be in immediate mode"
  defp get_address_where_write_for(instruction, memory, parameter_offset) do
    parameter_mode = get_parameter_mode_for(instruction, parameter_offset)
    case(parameter_mode) do
      :relative -> memory_at(memory, instruction.memory_pointer + parameter_offset) + instruction.relative_base
      _ -> memory_at(memory, instruction.memory_pointer + parameter_offset)
    end
  end

  defp get_parameter_mode_for(instruction, 1), do: instruction.code.first_parameter_mode
  defp get_parameter_mode_for(instruction, 2), do: instruction.code.second_parameter_mode
  defp get_parameter_mode_for(instruction, 3), do: instruction.code.third_parameter_mode

  defp memory_at(memory, address), do: Enum.at(memory, address, 0)

end
