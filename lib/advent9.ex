defmodule Advent9 do

  def resolve do
    read_initial_memory_from_file()
      |> Intcode.MachineState.new([1])
      |> Intcode.Machine.run_with()
      |> elem(0)
      |> Map.get(:outputs_stack)
  end

  defp read_initial_memory_from_file do
    File.stream!("advent9.txt")
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn({n, _}) -> n end)
  end

end
