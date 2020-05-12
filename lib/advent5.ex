defmodule Instruction do
  @enforce_keys [:code, :memory_pointer, :length]
  defstruct @enforce_keys

  def build_from(instruction_code, memory_pointer) do
    instruction_length = case(instruction_code.opcode) do
      3 -> 2
      _ -> 4
    end
    %Instruction{
      code: instruction_code,
      memory_pointer: memory_pointer,
      length: instruction_length
    }
  end
end

defmodule InstructionCode do
  defstruct opcode: 1, first_parameter_mode: 0, second_parameter_mode: 0, third_parameter_mode: 0

  def build_from(code) do
    %InstructionCode{
      opcode: rem(code, 100),
      first_parameter_mode: rem(div(code, 100), 10),
      second_parameter_mode: rem(div(code, 1000), 10),
      third_parameter_mode: div(code, 10000)
    }
  end
end

defmodule Advent5 do

  def resolve do
    read_initial_memory_from_file()
      |> run_memory_program_from_instruction(0, 1)
  end

  def run_memory_program_from_instruction(memory, instruction_pointer, input) do
    instruction_code = memory |> Enum.at(instruction_pointer) |> InstructionCode.build_from
    instruction = Instruction.build_from(instruction_code, instruction_pointer)

    if(halt_program_instruction?(instruction)) do
      memory
    else
      memory
        |> compute_instruction(instruction, input)
        |> run_memory_program_from_instruction(instruction_pointer + instruction.length, input)
    end
  end

  defp halt_program_instruction?(%{code: %{opcode: 99}}), do: true
  defp halt_program_instruction?(_), do: false

  defp read_initial_memory_from_file do
    File.stream!("advent5.txt")
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn({n, _}) -> n end)
  end


  defp compute_instruction(memory, %{code: %{opcode: 3}} = instruction, input) do
    first_parameter = Enum.at(memory, instruction.memory_pointer + 1)
    memory |> List.replace_at(first_parameter, input)
  end

  defp compute_instruction(memory, instruction, _input) do
    first_parameter = case(instruction.code.first_parameter_mode) do
      1 -> Enum.at(memory, instruction.memory_pointer + 1)
      0 -> Enum.at(memory, Enum.at(memory, instruction.memory_pointer + 1))
    end
    second_parameter = case(instruction.code.second_parameter_mode) do
      1 -> Enum.at(memory, instruction.memory_pointer + 2)
      0 -> Enum.at(memory, Enum.at(memory, instruction.memory_pointer + 2))
    end
    third_parameter = Enum.at(memory, instruction.memory_pointer + 3)

    instruction_result = case(instruction.code.opcode) do
      1 -> first_parameter + second_parameter
      2 -> first_parameter * second_parameter
    end
    List.replace_at(memory, third_parameter, instruction_result)
  end

end

