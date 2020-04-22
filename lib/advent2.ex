defmodule Advent2 do

  def resolve_second_part do
    inputs = 0..99 |> Stream.flat_map(fn(noun) ->
      0..99 |> Stream.map(fn(verb) ->
        program_result = resolve_first_part(noun, verb)
        {noun, verb, program_result}
      end)
    end)

    {noun, verb, _program_result} = inputs
      |> Enum.find(fn({_noun, _verb, program_result}) ->
        program_result == 19690720
      end)

    (100 * noun) + verb
  end

  def resolve_first_part(noun \\ 12, verb \\ 2) do
    read_initial_memory_from_file()
      |> put_inputs_in_memory(noun, verb)
      |> run_memory_program()
      |> Enum.at(0)
  end

  def run_memory_program(memory, instruction_pointer \\ 0) do
    instruction = Enum.slice(memory, instruction_pointer, 4)
    if(halt_program_instruction?(instruction)) do
      memory
    else
      memory
        |> compute_instruction(instruction)
        |> run_memory_program(instruction_pointer + 4)
    end
  end

  defp read_initial_memory_from_file do
    File.stream!("advent2.txt")
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn({n, _}) -> n end)
  end

  defp put_inputs_in_memory(memory, noun, verb) do
    memory
      |> List.replace_at(1, noun)
      |> List.replace_at(2, verb)
  end

  defp halt_program_instruction?(instruction) do
    case(instruction) do
      [99 | _] -> true
      _ -> false
    end
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
