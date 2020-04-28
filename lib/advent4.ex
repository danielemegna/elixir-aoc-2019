defmodule Advent4 do

  def resolve do
    197487..673251
      |> Enum.map(&Integer.to_string/1)
      |> Enum.filter(&meets_criteria?/1)
      |> Enum.count
  end

  def meets_criteria?(password) do
    password_digits = String.graphemes(password)
    has_two_adjacent_digits?(password_digits) &&
      digits_never_decrease?(password_digits)
  end

  defp has_two_adjacent_digits?(password_digits) do
    password_digits
      |> Stream.with_index
      |> Enum.any?(fn {digit, index} ->
        digit == Enum.at(password_digits, index+1)
      end)
  end

  defp digits_never_decrease?(password_digits) do
    password_digits
      |> Stream.with_index
      |> Enum.all?(fn {digit, index} ->
        next_digit = Enum.at(password_digits, index+1)
        index == (Enum.count(password_digits)-1) || Integer.parse(digit) <= Integer.parse(next_digit)
      end)
  end

end
