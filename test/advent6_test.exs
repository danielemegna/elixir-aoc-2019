defmodule Advent6Test do
  use ExUnit.Case

  test "total_number_of_orbits counts total orbits in a map" do
    map = [
      {"COM","B"},
      {"B","C"}
    ]
    assert 3 == Advent6.total_number_of_orbits(map)

    map = [
      {"COM","B"},
      {"B","C"},
      {"C","D"},
      {"D","E"},
      {"E","F"},
      {"B","G"},
      {"G","H"},
      {"D","I"},
      {"E","J"},
      {"J","K"},
      {"K","L"}
    ]
    assert 42 == Advent6.total_number_of_orbits(map)
  end
end
