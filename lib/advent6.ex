defmodule Advent6 do

  def resolve do
    read_raw_map_from_file()
      |> total_number_of_orbits
  end

  def total_number_of_orbits(raw_map) do
    orbiting_to_orbited_map = raw_map_to_orbiting_map(raw_map)

    orbiting_to_orbited_map
      |> Map.keys
      |> Enum.map(fn(orbiting) -> number_of_orbits(orbiting, orbiting_to_orbited_map) end)
      |> Enum.sum
  end

  defp number_of_orbits(orbiting, orbiting_to_orbited_map) do
    orbited = Map.get(orbiting_to_orbited_map, orbiting)
    if(orbited === "COM") do
      1 
    else
      new_orbiting = orbited
      1 + number_of_orbits(new_orbiting, orbiting_to_orbited_map)
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
