defmodule Instruction do
  @enforce_keys [:code, :memory_pointer, :length]
  defstruct @enforce_keys

  def build_from(instruction_code_from_memory, memory_pointer) do
    instruction_code = InstructionCode.build_from(instruction_code_from_memory)
    instruction_length = case(instruction_code.opcode) do
      op when op in [1, 2, 7, 8] -> 4
      op when op in [3, 4] -> 2
      op when op in [5, 6] -> 3
      99 -> 1
    end
    %Instruction{
      code: instruction_code,
      memory_pointer: memory_pointer,
      length: instruction_length
    }
  end

  def first_parameter_from(%{code: %{opcode: 3}} = instruction, memory) do
    # "Parameters that an instruction writes to will never be in immediate mode"
    Enum.at(memory, instruction.memory_pointer + 1)
  end

  def first_parameter_from(instruction, memory) do
    case(instruction.code.first_parameter_mode) do
      1 -> Enum.at(memory, instruction.memory_pointer + 1)
      0 -> Enum.at(memory, Enum.at(memory, instruction.memory_pointer + 1))
    end
  end

  def second_parameter_from(instruction, memory) do
    case(instruction.code.second_parameter_mode) do
      1 -> Enum.at(memory, instruction.memory_pointer + 2)
      0 -> Enum.at(memory, Enum.at(memory, instruction.memory_pointer + 2))
    end
  end

  def third_parameter_from(%{code: %{opcode: opcode}} = instruction, memory) when opcode in [1, 2, 7, 8] do
    # "Parameters that an instruction writes to will never be in immediate mode"
    Enum.at(memory, instruction.memory_pointer + 3)
  end

  def third_parameter_from(instruction, memory) do
    case(instruction.code.third_parameter_mode) do
      1 -> Enum.at(memory, instruction.memory_pointer + 3)
      0 -> Enum.at(memory, Enum.at(memory, instruction.memory_pointer + 3))
    end
  end

end

defmodule InstructionCode do
  @enforce_keys [:opcode, :first_parameter_mode, :second_parameter_mode, :third_parameter_mode]
  defstruct @enforce_keys

  def build_from(instruction_code_from_memory) do
    %InstructionCode{
      opcode: rem(instruction_code_from_memory, 100),
      first_parameter_mode: rem(div(instruction_code_from_memory, 100), 10),
      second_parameter_mode: rem(div(instruction_code_from_memory, 1000), 10),
      third_parameter_mode: div(instruction_code_from_memory, 10000)
    }
  end
end

defmodule Advent5 do

  def resolve do
    {_, output} = read_initial_memory_from_file()
      |> run_memory_program_from_instruction(0, 1, [])

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

  defp halt_program_instruction?(%{code: %{opcode: 99}}), do: true
  defp halt_program_instruction?(_), do: false

  defp compute_instruction(memory, %{code: %{opcode: 3}} = instruction, input_value, outputs_stack) do
    first_parameter = Instruction.first_parameter_from(instruction, memory)
    new_memory = memory |> List.replace_at(first_parameter, input_value)
    { new_memory, instruction.memory_pointer + instruction.length, outputs_stack }
  end

  defp compute_instruction(memory, %{code: %{opcode: 4}} = instruction, _input_value, outputs_stack) do
    first_parameter = Instruction.first_parameter_from(instruction, memory)
    new_outputs_stack = outputs_stack ++ [first_parameter]
    { memory, instruction.memory_pointer + instruction.length, new_outputs_stack }
  end

  defp compute_instruction(memory, %{code: %{opcode: 5}} = instruction, _input_value, outputs_stack) do
    first_parameter = Instruction.first_parameter_from(instruction, memory)
    second_parameter = Instruction.second_parameter_from(instruction, memory)
    new_instruction_pointer = if(first_parameter != 0) do
      second_parameter
    else
      instruction.memory_pointer + instruction.length
    end
      
    { memory, new_instruction_pointer, outputs_stack }
  end

  defp compute_instruction(memory, %{code: %{opcode: 6}} = instruction, _input_value, outputs_stack) do
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
      1 -> first_parameter + second_parameter
      2 -> first_parameter * second_parameter
      7 -> (if (first_parameter < second_parameter), do: 1, else: 0)
      8 -> (if (first_parameter == second_parameter), do: 1, else: 0)
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

