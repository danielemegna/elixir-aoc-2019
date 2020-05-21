defmodule Advent6 do

  def resolve do
    read_raw_map_from_file()
      |> total_number_of_orbits
  end

  def total_number_of_orbits(raw_map) do
    orbiting_to_orbited_map = raw_map_to_orbiting_map(raw_map)
    orbiting_list = Map.keys(orbiting_to_orbited_map)

    orbiting_list
      |> Enum.map(fn(orbiting) -> path_to_center_of_mass(orbiting, orbiting_to_orbited_map) end)
      |> Enum.map(&Enum.count/1)
      |> Enum.sum
  end

  defp path_to_center_of_mass(orbiting, orbiting_to_orbited_map, partial_reversed_path \\ []) do
    orbited = Map.get(orbiting_to_orbited_map, orbiting)
    reversed_path = [orbited | partial_reversed_path]
    if(orbited === "COM") do
      reversed_path |> Enum.reverse
    else
      new_orbiting = orbited
      path_to_center_of_mass(new_orbiting, orbiting_to_orbited_map, reversed_path)
    end
  end

  defp raw_map_to_orbiting_map(raw_map) do
    Enum.reduce(raw_map, %{}, fn({orbited, orbiting}, acc) ->
      Map.put(acc, orbiting,  orbited)
    end)
  end

  defp read_raw_map_from_file do
    File.stream!("advent6.txt")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&(String.split(&1, ")")))
      |> Enum.map(fn([orbiting, orbited]) -> {orbiting, orbited} end)
  end

end
