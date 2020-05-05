defmodule Advent5 do

  def resolve do
    read_initial_memory_from_file()
      |> run_memory_program_with_input(1)
  end

  def run_memory_program_from_instruction(memory, instruction_pointer) do
    instruction = Enum.slice(memory, instruction_pointer, 4)
    if(halt_program_instruction?(instruction)) do
      memory
    else
      memory
        |> compute_instruction(instruction)
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
    case(instruction) do
      [99 | _] -> true
      _ -> false
    end
  end

  defp compute_instruction(memory, [3, parameter]) do
    List.replace_at(memory, parameter, 42)
  end

  defp compute_instruction(memory, [4, parameter]) do
    IO.puts Enum.at(memory, parameter)
  end

  defp compute_instruction(memory, [opcode, first_parameter_position, second_parameter_position, result_position]) do
    first_parameter = Enum.at(memory, first_parameter_position)
    second_parameter = Enum.at(memory, second_parameter_position)
    instruction_result = case(opcode) do
      1 -> first_parameter + second_parameter
      2 -> first_parameter * second_parameter
    end
    List.replace_at(memory, result_position, instruction_result)
  end

end
