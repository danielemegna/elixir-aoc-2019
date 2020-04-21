defmodule Advent2 do

  def resolve do
    File.stream!("advent2.txt")
      |> Enum.map(&Integer.parse/1)
      |> resolve
  end

  def resolve(vector) do
    vector
      |> Enum.slice(0, Enum.find_index(vector, &(&1 == 99)))
      |> Enum.chunk_every(4)
      |> Enum.reduce(vector, fn(chunk, acc) ->
        compute_four(chunk, acc)
      end)
  end

  def compute_four(full_vector), do: compute_four(full_vector, full_vector)
  def compute_four([operation, first_position, second_position, result_position], full_vector) do
    operation_result = perform_operation(
      operation,
      Enum.at(full_vector, first_position),
      Enum.at(full_vector, second_position)
    )
    full_vector |> List.replace_at(result_position, operation_result)
  end

  defp perform_operation(1, first, second), do: first + second
  defp perform_operation(2, first, second), do: first * second

end
