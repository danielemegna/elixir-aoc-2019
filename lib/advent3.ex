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

  def fill_grid_with(grid, [next_movement | rest], from_coordinates) do
    {direction, steps} = String.split_at(next_movement, 1)
    {steps, _} = Integer.parse(steps)
    {current_x, current_y} = from_coordinates

    {new_grid, new_coordinates} = case(direction) do
      "R" ->
        new_grid = grid |> fill_grid_with(from_coordinates, steps, :right)
        new_coordinates = {current_x + steps, current_y}
        {new_grid, new_coordinates}
      "L" ->
        new_grid = grid |> fill_grid_with(from_coordinates, steps, :left)
        new_coordinates = {current_x - steps, current_y}
        {new_grid, new_coordinates}
      "U" ->
        new_grid = grid |> fill_grid_with(from_coordinates, steps, :up)
        new_coordinates = {current_x, current_y + steps}
        {new_grid, new_coordinates}
      "D" ->
        new_grid = grid |> fill_grid_with(from_coordinates, steps, :down)
        new_coordinates = {current_x, current_y - steps}
        {new_grid, new_coordinates}
    end

    new_grid |> fill_grid_with(rest, new_coordinates)
  end

  def fill_grid_with(grid, [], _), do: grid

  def fill_grid_with(grid, from_coordinates, steps, direction) do
    {from_x, from_y} = from_coordinates
    for i <- 1..steps, into: grid do
      case(direction) do
        :right -> { from_x + i, from_y }
        :left -> { from_x - i, from_y }
        :up -> { from_x, from_y + i }
        :down -> { from_x, from_y - i }
      end
    end
  end

  defp read_wire_movements_from_file do
    File.stream!("advent3.txt")
      |> Enum.map(&(String.split(&1, ",")))
  end

end
