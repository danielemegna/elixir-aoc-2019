defmodule Advent4 do

  def resolve_first_part do
    199999..669999 # 197487..673251
      |> Enum.filter(&meets_first_part_criteria?/1)
      |> Enum.count
  end

  def resolve_second_part do
    199999..669999 # 197487..673251
      |> Enum.filter(&meets_second_part_criteria?/1)
      |> Enum.count
  end

  def meets_first_part_criteria?(password) do
    password_digits = Integer.digits(password)
    digits_never_decrease?(password_digits) &&
      has_two_adjacent_digits?(password_digits)
  end

  def meets_second_part_criteria?(password) do
    password_digits = Integer.digits(password)
    digits_never_decrease?(password_digits) &&
      has_two_adjacent_digits_alone?(password_digits)
  end

  defp digits_never_decrease?([first, second | _]) when (first > second), do: false
  defp digits_never_decrease?([_ | rest]), do: digits_never_decrease?(rest)
  defp digits_never_decrease?([]), do: true
  
  defp has_two_adjacent_digits?([first, second | _]) when first == second, do: true
  defp has_two_adjacent_digits?([_ | rest]), do: has_two_adjacent_digits?(rest)
  defp has_two_adjacent_digits?([]), do: false

  defp has_two_adjacent_digits_alone?(digits, previous \\ nil)
  defp has_two_adjacent_digits_alone?([first, second | rest], previous) do
    if(first == second && first != previous && second != Enum.at(rest, 0)) do
      true
    else
      has_two_adjacent_digits_alone?([second | rest], first)
    end
  end
  defp has_two_adjacent_digits_alone?(_, _), do: false

end
