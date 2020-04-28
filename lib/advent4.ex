defmodule Advent4 do

  def resolve do
    197487..673251
      |> Enum.map(&Integer.to_string/1)
      |> Enum.filter(&meets_criteria?/1)
      |> Enum.count
  end

  def meets_criteria?(password) do
    has_two_adjacent_digits?(password) && digits_never_decrease?(password)
  end

  defp has_two_adjacent_digits?(password) do
    true
  end

  defp digits_never_decrease?(password) do
    true
  end

end
