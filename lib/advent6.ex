defmodule Advent6 do

  def total_number_of_orbits(map) do
    map
      |> Enum.map(fn(pair) -> number_of_orbits(pair, map) end)
      |> Enum.sum
  end

  def number_of_orbits({object, orbitant}, map) do
    if(object === "COM") do
      1 
    else
      new_object = Enum.find(map, fn {x, y} -> y == object end) |> elem(0)
      new_orbitant = object
      1 + number_of_orbits({new_object, new_orbitant}, map)
    end
  end

end
