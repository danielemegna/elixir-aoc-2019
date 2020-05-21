defmodule Advent6 do

  def resolve_first_part do
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

  def resolve_second_part do
    raw_map = read_raw_map_from_file()
    minimum_orbital_transfer_count_between("YOU", "SAN", raw_map)
  end

  def minimum_orbital_transfer_count_between(source, target, raw_map) do
    orbiting_to_orbited_map = raw_map_to_orbiting_map(raw_map)
    source_to_com = path_to_center_of_mass(source, orbiting_to_orbited_map)
    target_to_com = path_to_center_of_mass(target, orbiting_to_orbited_map)

    common_orbites = MapSet.intersection(MapSet.new(source_to_com), MapSet.new(target_to_com))
      |> Enum.filter(&(&1 != "COM"))

    Enum.map(common_orbites, fn(common_orbite) ->
      source_to_common_transfer_count = source_to_com
        |> Enum.take_while(fn x -> x != common_orbite end)
        |> Enum.count
      target_to_common_transfer_count = target_to_com
        |> Enum.take_while(fn x -> x != common_orbite end)
        |> Enum.count

      source_to_common_transfer_count + target_to_common_transfer_count
    end)
    |> Enum.min
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
