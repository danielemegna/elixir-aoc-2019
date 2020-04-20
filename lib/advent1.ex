defmodule Advent1 do

  def resolve() do
    File.stream!("advent1.txt")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn({n, _}) -> n end)
      |> Enum.map(&calc/1)
      |> Enum.sum
  end

  def calc(x) do
    x
      |> Decimal.new()
      |> Decimal.div(3)
      |> Decimal.round(0, :down) 
      |> Decimal.to_integer
      |> Kernel.-(2)
  end

end
