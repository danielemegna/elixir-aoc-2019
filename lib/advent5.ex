defmodule Instruction do
  @enforce_keys [:code, :memory_pointer, :length]
  defstruct @enforce_keys

  def build_from(instruction_code_from_memory, memory_pointer) do
    instruction_code = InstructionCode.build_from(instruction_code_from_memory)
    %Instruction{
      code: instruction_code,
      memory_pointer: memory_pointer,
      length: instruction_length_for(instruction_code.opcode)
    }
  end

  # "Parameters that an instruction writes to will never be in immediate mode"
  def first_parameter_from(%{code: %{opcode: :read}} = instruction, memory), do:
    get_parameter_for(1, memory, instruction.memory_pointer, 1)

  def first_parameter_from(instruction, memory), do:
    get_parameter_for(instruction.code.first_parameter_mode, memory, instruction.memory_pointer, 1)

  def second_parameter_from(instruction, memory), do:
    get_parameter_for(instruction.code.second_parameter_mode, memory, instruction.memory_pointer, 2)

  # "Parameters that an instruction writes to will never be in immediate mode"
  def third_parameter_from(%{code: %{opcode: opcode}} = instruction, memory) when opcode in [:add, :mult, :less_than, :equals], do:
    get_parameter_for(1, memory, instruction.memory_pointer, 3)

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

  defp get_parameter_for(parameter_mode, memory, memory_pointer, memory_offset) do
    case(parameter_mode) do
      1 -> Enum.at(memory, memory_pointer + memory_offset)
      0 -> Enum.at(memory, Enum.at(memory, memory_pointer + memory_offset))
    end
  end

end

defmodule InstructionCode do
  @enforce_keys [:opcode, :first_parameter_mode, :second_parameter_mode, :third_parameter_mode]
  defstruct @enforce_keys

  def build_from(instruction_code_from_memory) do
    opcode = rem(instruction_code_from_memory, 100)
    %InstructionCode{
      opcode: opcode_to_atom(opcode),
      first_parameter_mode: rem(div(instruction_code_from_memory, 100), 10),
      second_parameter_mode: rem(div(instruction_code_from_memory, 1000), 10),
      third_parameter_mode: div(instruction_code_from_memory, 10000)
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
      99 -> :halt
    end
  end
end

defmodule Advent5 do

  def resolve_first_part do
    memory = read_initial_memory_from_file()
    {_final_memory, output} = run_memory_program_from_instruction(memory, 0, 1, [])
    output
  end

  def resolve_second_part do
    memory = read_initial_memory_from_file()
    {_final_memory, output} = run_memory_program_from_instruction(memory, 0, 5, [])
    output
  end

  def run_memory_program_from_instruction(memory, instruction_pointer, input_value, outputs_stack) do
    instruction = Instruction.build_from(
      Enum.at(memory, instruction_pointer),
      instruction_pointer
    )

    if(halt_program_instruction?(instruction)) do
      { memory, outputs_stack }
    else
      { new_memory, new_instruction_pointer, new_outputs_stack } =
        compute_instruction(memory, instruction, input_value, outputs_stack)

      run_memory_program_from_instruction(
        new_memory, new_instruction_pointer, input_value, new_outputs_stack
      )
    end
  end

  defp halt_program_instruction?(%{code: %{opcode: :halt}}), do: true
  defp halt_program_instruction?(_), do: false

  defp compute_instruction(memory, %{code: %{opcode: :read}} = instruction, input_value, outputs_stack) do
    first_parameter = Instruction.first_parameter_from(instruction, memory)
    new_memory = memory |> List.replace_at(first_parameter, input_value)
    { new_memory, instruction.memory_pointer + instruction.length, outputs_stack }
  end

  defp compute_instruction(memory, %{code: %{opcode: :write}} = instruction, _input_value, outputs_stack) do
    first_parameter = Instruction.first_parameter_from(instruction, memory)
    new_outputs_stack = outputs_stack ++ [first_parameter]
    { memory, instruction.memory_pointer + instruction.length, new_outputs_stack }
  end

  defp compute_instruction(memory, %{code: %{opcode: :jump_if_true}} = instruction, _input_value, outputs_stack) do
    first_parameter = Instruction.first_parameter_from(instruction, memory)
    second_parameter = Instruction.second_parameter_from(instruction, memory)
    new_instruction_pointer = if(first_parameter != 0) do
      second_parameter
    else
      instruction.memory_pointer + instruction.length
    end
      
    { memory, new_instruction_pointer, outputs_stack }
  end

  defp compute_instruction(memory, %{code: %{opcode: :jump_if_false}} = instruction, _input_value, outputs_stack) do
    first_parameter = Instruction.first_parameter_from(instruction, memory)
    second_parameter = Instruction.second_parameter_from(instruction, memory)
    new_instruction_pointer = if(first_parameter == 0) do
      second_parameter
    else
      instruction.memory_pointer + instruction.length
    end
      
    { memory, new_instruction_pointer, outputs_stack }
  end

  defp compute_instruction(memory, instruction, _input_value, outputs_stack) do
    first_parameter = Instruction.first_parameter_from(instruction, memory)
    second_parameter = Instruction.second_parameter_from(instruction, memory)
    third_parameter = Instruction.third_parameter_from(instruction, memory)

    instruction_result = case(instruction.code.opcode) do
      :add -> first_parameter + second_parameter
      :mult -> first_parameter * second_parameter
      :less_than -> (if (first_parameter < second_parameter), do: 1, else: 0)
      :equals -> (if (first_parameter == second_parameter), do: 1, else: 0)
    end
    new_memory = memory |> List.replace_at(third_parameter, instruction_result)
    { new_memory, instruction.memory_pointer + instruction.length, outputs_stack }
  end

  defp read_initial_memory_from_file do
    File.stream!("advent5.txt")
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn({n, _}) -> n end)
  end

end

