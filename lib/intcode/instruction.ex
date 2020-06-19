defmodule Intcode.Instruction do
  alias __MODULE__

  @enforce_keys [:code, :memory_pointer, :length]
  defstruct @enforce_keys

  def build_from(instruction_code_from_memory, memory_pointer) do
    instruction_code = Intcode.InstructionCode.build_from(instruction_code_from_memory)
    %Instruction{
      code: instruction_code,
      memory_pointer: memory_pointer,
      length: instruction_length_for(instruction_code.opcode)
    }
  end

  # "Parameters that an instruction writes to will never be in immediate mode"
  def first_parameter_from(%{code: %{opcode: :read}} = instruction, memory), do:
    get_parameter_for(:immediate, memory, instruction.memory_pointer, 1)

  def first_parameter_from(instruction, memory), do:
    get_parameter_for(instruction.code.first_parameter_mode, memory, instruction.memory_pointer, 1)

  def second_parameter_from(instruction, memory), do:
    get_parameter_for(instruction.code.second_parameter_mode, memory, instruction.memory_pointer, 2)

  # "Parameters that an instruction writes to will never be in immediate mode"
  def third_parameter_from(%{code: %{opcode: opcode}} = instruction, memory) when opcode in [:add, :mult, :less_than, :equals], do:
    get_parameter_for(:immediate, memory, instruction.memory_pointer, 3)

  def third_parameter_from(instruction, memory), do:
    get_parameter_for(instruction.code.third_parameter_mode, memory, instruction.memory_pointer, 3)

  defp instruction_length_for(opcode) do
    case(opcode) do
      op when op in [:add, :mult, :less_than, :equals] -> 4
      op when op in [:read, :write] -> 2
      op when op in [:jump_if_true, :jump_if_false] -> 3
      :halt -> 1
    end
  end

  defp get_parameter_for(parameter_mode, memory, memory_pointer, parameter_offset) do
    case(parameter_mode) do
      :immediate -> Enum.at(memory, memory_pointer + parameter_offset)
      :position -> Enum.at(memory, Enum.at(memory, memory_pointer + parameter_offset))
      :relative -> Enum.at(memory, Enum.at(memory, memory_pointer + parameter_offset))
    end
  end

end
