defmodule Advent2 do

  def resolve_first_part do
    read_initial_memory_from_file()
      |> put_inputs_in_memory__run__and_take_result(12, 2)
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
        |> put_inputs_in_memory__run__and_take_result(noun, verb)
        |> Kernel.==(19690720)
    end)
    
    (100 * result_noun) + result_verb
  end

  defp put_inputs_in_memory__run__and_take_result(memory, noun, verb) do
    memory
      |> put_inputs_in_memory(noun, verb)
      |> Intcode.Machine.run_memory_program_from_instruction(0, [], [])
      |> elem(0)
      |> Enum.at(0)
  end

  defp put_inputs_in_memory(memory, noun, verb) do
    memory
      |> List.replace_at(1, noun)
      |> List.replace_at(2, verb)
  end

  defp read_initial_memory_from_file do
    File.stream!("advent2.txt")
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn({n, _}) -> n end)
  end

end
