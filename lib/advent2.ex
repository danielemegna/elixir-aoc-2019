defmodule Advent2 do

  def resolve do
    File.stream!("advent2.txt")
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn({n, _}) -> n end)
      |> List.replace_at(1, 12)
      |> List.replace_at(2, 2)
      |> resolve
  end

  def resolve(vector, index \\ 0) do
    if(Enum.at(vector, index) == 99) do
      vector
    else
      slice = Enum.slice(vector, index, 4)
      vector = compute_slice(slice, vector)
      resolve(vector, index + 4)
    end
  end

  defp compute_slice([operation, first_position, second_position, result_position], full_vector) do
    first = Enum.at(full_vector, first_position)
    second = Enum.at(full_vector, second_position)
    operation_result = case(operation) do
      1 -> first + second
      2 -> first * second
    end
    List.replace_at(full_vector, result_position, operation_result)
  end

end
