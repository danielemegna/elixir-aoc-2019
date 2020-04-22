defmodule Advent2 do

  def resolve_first_part do
    read_initial_memory_from_file()
      |> run_memory_program_with_input(12, 2)
  end

  def resolve_second_part do
    initial_memory = read_initial_memory_from_file()

    all_input_pairs = 99..0 |> Stream.flat_map(fn(noun) ->
      99..0 |> Stream.map(fn(verb) ->
        {noun, verb}
      end)
    end)

    {result_noun, result_verb} = Enum.find(all_input_pairs, fn({noun, verb}) ->
      initial_memory
        |> run_memory_program_with_input(noun, verb)
        |> Kernel.==(19690720)
    end)
    
    (100 * result_noun) + result_verb
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

  defp run_memory_program_with_input(memory, noun, verb) do
    memory
      |> put_inputs_in_memory(noun, verb)
      |> run_memory_program_from_instruction(0)
      |> Enum.at(0)
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
