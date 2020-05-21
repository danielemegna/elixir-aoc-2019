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

  test "resolve level" do
    assert 200001 == Advent6.resolve
  end

  test "minimum_orbital_transfer_count_between test" do
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
      {"K","L"},
      {"K","YOU"},
      {"I","SAN"}
    ]

    assert 4 == Advent6.minimum_orbital_transfer_count_between("YOU", "SAN", map)
  end
end
