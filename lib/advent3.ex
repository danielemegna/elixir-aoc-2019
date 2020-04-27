defmodule Advent3 do

  def resolve do
    [first_wire_movements, second_wire_movements] = read_wire_movements_from_file()
    find_closest_cross_manhattan_distance(first_wire_movements, second_wire_movements)
  end

  def find_closest_cross_manhattan_distance(first_wire_movements, second_wire_movements) do
    first_grid = MapSet.new |> fill_grid_with(first_wire_movements, {0,0})
    second_grid = MapSet.new |> fill_grid_with(second_wire_movements, {0,0})

    MapSet.intersection(first_grid, second_grid)
      |> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
      |> Enum.sort
      |> Enum.at(0)
  end

  def fill_grid_with(grid, [movement | rest], current_coordinate) do
    {direction, steps_number} = String.split_at(movement, 1)
    {steps_number, _} = Integer.parse(steps_number)

    occupied_coordinates = 1..steps_number |> Enum.map(fn(step_index) ->
      increase_coordinate(current_coordinate, direction, step_index)
    end)

    new_grid = MapSet.union(grid, MapSet.new(occupied_coordinates))
    new_coordinate = increase_coordinate(current_coordinate, direction, steps_number)

    fill_grid_with(new_grid, rest, new_coordinate)
  end

  def fill_grid_with(grid, [], _), do: grid

  defp increase_coordinate({x, y}, "R", count), do: {x + count, y}
  defp increase_coordinate({x, y}, "L", count), do: {x - count, y}
  defp increase_coordinate({x, y}, "U", count), do: {x, y + count}
  defp increase_coordinate({x, y}, "D", count), do: {x, y - count}

  defp read_wire_movements_from_file do
    File.stream!("advent3.txt")
      |> Enum.map(&(String.split(&1, ",")))
  end

end
