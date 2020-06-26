defmodule Advent5 do

  def resolve_first_part do
    memory = read_initial_memory_from_file()
    {_final_memory, _last_instruction, outputs} = Intcode.Machine.run_with(Intcode.MachineState.new(memory, [1]))
    outputs
  end

  def resolve_second_part do
    memory = read_initial_memory_from_file()
    {_final_memory, _last_instruction, outputs} = Intcode.Machine.run_with(Intcode.MachineState.new(memory, [5]))
    outputs
  end

  defp read_initial_memory_from_file do
    File.stream!("advent5.txt")
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn({n, _}) -> n end)
  end

end

