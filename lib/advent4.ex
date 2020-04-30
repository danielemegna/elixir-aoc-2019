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
      has_only_two_adjacent_digits?(password_digits)
  end

  defp has_two_adjacent_digits?([first, second | _]) when first == second, do: true
  defp has_two_adjacent_digits?([_ | rest]), do: has_two_adjacent_digits?(rest)
  defp has_two_adjacent_digits?([]), do: false

  defp has_only_two_adjacent_digits?([first, second, third | rest]) do
    if(first == second && first != third) do
      true
    else
      if(first == second) do
        has_only_two_adjacent_digits?([third | rest])
      else
        has_only_two_adjacent_digits?([second, third | rest])
      end
    end
  end
  defp has_only_two_adjacent_digits?(_), do: false

  defp digits_never_decrease?([first, second | _]) when (first > second), do: false
  defp digits_never_decrease?([_ | rest]), do: digits_never_decrease?(rest)
  defp digits_never_decrease?([]), do: true

end
