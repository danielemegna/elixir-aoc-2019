defmodule Advent3Test do
  use ExUnit.Case

  test "fill_grid_with some steps" do
    inital_grid = []
    steps = ["R3","D5","R2"]
    from_coordinate = {1946, 1946}
    current_length = 10

    filled_grid = Advent3.fill_grid_with(inital_grid, steps, from_coordinate, current_length)

    expected = [
      %{coordinate: {1946 + 1, 1946}, wire_length: 11},
      %{coordinate: {1946 + 2, 1946}, wire_length: 12},
      %{coordinate: {1946 + 3, 1946}, wire_length: 13},
      %{coordinate: {1946 + 3, 1946 - 1}, wire_length: 14},
      %{coordinate: {1946 + 3, 1946 - 2}, wire_length: 15},
      %{coordinate: {1946 + 3, 1946 - 3}, wire_length: 16},
      %{coordinate: {1946 + 3, 1946 - 4}, wire_length: 17},
      %{coordinate: {1946 + 3, 1946 - 5}, wire_length: 18},
      %{coordinate: {1946 + 4, 1946 - 5}, wire_length: 19},
      %{coordinate: {1946 + 5, 1946 - 5}, wire_length: 20}
    ]

    assert filled_grid == expected
  end

  test "find_closest_cross_manhattan_distance function test (provided example 1)" do
    first_wire_movements = ["R75","D30","R83","U83","L12","D49","R71","U7","L72"]
    second_wire_movements = ["U62","R66","U55","R34","D71","R55","D58","R83"]

    assert 159 == Advent3.find_closest_cross_manhattan_distance(first_wire_movements, second_wire_movements)
  end

  test "find_closest_cross_manhattan_distance function test (provided example 2)" do
    first_wire_movements = ["R98","U47","R26","D63","R33","U87","L62","D20","R33","U53","R51"]
    second_wire_movements = ["U98","R91","D20","R16","D67","R40","U7","R15","U6","R7"]

    assert 135 == Advent3.find_closest_cross_manhattan_distance(first_wire_movements, second_wire_movements)
  end

  test "resolve level (first part)" do
    assert 896 == Advent3.resolve_first_part
  end

end
