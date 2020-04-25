defmodule Advent3Test do
  use ExUnit.Case

  test "fill_grid_with single right step" do
    from_coordinates = {1946, 1946}
    inital_grid = %{}

    filled_grid = Advent3.fill_grid_with(inital_grid, from_coordinates, 2, :right)

    expected = %{
      {1946 + 1, 1946} => :busy,
      {1946 + 2, 1946} => :busy
    }

    assert filled_grid == expected
  end

  test "fill_grid_with single down step" do
    from_coordinates = {1946, 1946}
    inital_grid = %{}

    filled_grid = Advent3.fill_grid_with(inital_grid, from_coordinates, 3, :down)

    expected = %{
      {1946, 1946 - 1} => :busy,
      {1946, 1946 - 2} => :busy,
      {1946, 1946 - 3} => :busy
    }

    assert filled_grid == expected
  end

  test "fill_grid_with multiple steps" do
    central_port_coordinates = {1946, 1946}
    inital_grid = %{
      central_port_coordinates => :central_port
    }

    filled_grid = Advent3.fill_grid_with(["R3","D5","R2"], inital_grid, central_port_coordinates)

    expected = %{
      central_port_coordinates => :central_port,
      {1946 + 1, 1946} => :busy,
      {1946 + 2, 1946} => :busy,
      {1946 + 3, 1946} => :busy,
      {1946 + 3, 1946 - 1} => :busy,
      {1946 + 3, 1946 - 2} => :busy,
      {1946 + 3, 1946 - 3} => :busy,
      {1946 + 3, 1946 - 4} => :busy,
      {1946 + 3, 1946 - 5} => :busy,
      {1946 + 4, 1946 - 5} => :busy,
      {1946 + 5, 1946 - 5} => :busy
    }

    assert filled_grid == expected
  end

  test "find_closest_cross_manhattan_distance function test" do
    first_wire_movements = ["R75","D30","R83","U83","L12","D49","R71","U7","L72"]
    second_wire_movements = ["U62","R66","U55","R34","D71","R55","D58","R83"]

    assert 159 = Advent3.find_closest_cross_manhattan_distance(first_wire_movements, second_wire_movements)
  end

  test "resolve level" do
    Advent3.resolve
  end
end
