defmodule Advent4 do

  def resolve do
    199999..669999 # 197487..673251
      |> Enum.filter(&meets_criteria?/1)
      |> Enum.count
  end

  def meets_criteria?(password) do
    password_digits = Integer.digits(password)
    has_two_adjacent_digits?(password_digits) &&
      digits_never_decrease?(password_digits)
  end

  defp has_two_adjacent_digits?([first, second | rest]) do
    if(first == second) do
      true
    else
      has_two_adjacent_digits?([second | rest])
    end
  end
  defp has_two_adjacent_digits?(_), do: false

  defp digits_never_decrease?([first, second | rest]) do
    if(first > second) do
      false
    else
      digits_never_decrease?([second | rest])
    end
  end
  defp digits_never_decrease?(_), do: true

end
