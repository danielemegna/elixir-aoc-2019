defmodule Advent4 do

  def resolve do
    199999..669999 # 197487..673251
      |> Enum.filter(&meets_criteria?/1)
      |> Enum.count
  end

  def meets_criteria?(password) do
    password_digits = Integer.digits(password)
    digits_never_decrease?(password_digits) &&
      has_two_adjacent_digits?(password_digits)
  end

  defp has_two_adjacent_digits?([first, second | _]) when first == second, do: true
  defp has_two_adjacent_digits?([_ | rest]), do: has_two_adjacent_digits?(rest)
  defp has_two_adjacent_digits?([]), do: false

  defp digits_never_decrease?([first, second | _]) when (first > second), do: false
  defp digits_never_decrease?([_ | rest]), do: digits_never_decrease?(rest)
  defp digits_never_decrease?([]), do: true

end
