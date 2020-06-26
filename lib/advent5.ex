defmodule Advent5 do

  def resolve_first_part do
    read_initial_memory_from_file()
      |> Intcode.MachineState.new([1])
      |> Intcode.Machine.run_with()
      |> elem(0)
      |> Map.get(:outputs_stack)
  end

  def resolve_second_part do
    read_initial_memory_from_file()
      |> Intcode.MachineState.new([5])
      |> Intcode.Machine.run_with()
      |> elem(0)
      |> Map.get(:outputs_stack)
  end

  defp read_initial_memory_from_file do
    File.stream!("advent5.txt")
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn({n, _}) -> n end)
  end

end

