defmodule Advent5 do

  def resolve do
    read_initial_memory_from_file()
      |> run_memory_program_with_input(1)
  end

  def run_memory_program_from_instruction(memory, instruction_pointer) do
    instruction = Instruction.build_from(Enum.at(memory, instruction_pointer))
    if(halt_program_instruction?(instruction)) do
      memory
    else
      memory
        |> compute_instruction(instruction, instruction_pointer)
        |> run_memory_program_from_instruction(instruction_pointer + 4)
    end
  end

  defp run_memory_program_with_input(memory, _input) do
    memory
  end

  defp read_initial_memory_from_file do
    File.stream!("advent5.txt")
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn({n, _}) -> n end)
  end

  defp halt_program_instruction?(instruction) do
    instruction.opcode == 99
  end

  defp compute_instruction(memory, instruction, instruction_pointer) do
    first_parameter = case(instruction.first_parameter_mode) do
      1 -> Enum.at(memory, instruction_pointer + 1)
      0 -> Enum.at(memory, Enum.at(memory, instruction_pointer + 1))
    end
    second_parameter = case(instruction.second_parameter_mode) do
      1 -> Enum.at(memory, instruction_pointer + 2)
      0 -> Enum.at(memory, Enum.at(memory, instruction_pointer + 2))
    end
    third_parameter = Enum.at(memory, instruction_pointer + 3)

    instruction_result = case(instruction.opcode) do
      1 -> first_parameter + second_parameter
      2 -> first_parameter * second_parameter
    end
    List.replace_at(memory, third_parameter, instruction_result)
  end

end

defmodule Instruction do
  defstruct opcode: 1, first_parameter_mode: 0, second_parameter_mode: 0, third_parameter_mode: 0

  def build_from(code) do
    %Instruction{
      opcode: rem(code, 100),
      first_parameter_mode: rem(div(code, 100), 10),
      second_parameter_mode: rem(div(code, 1000), 10),
      third_parameter_mode: div(code, 10000)
    }
  end

end
