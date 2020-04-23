defmodule Advent1 do

  def resolve_first_part() do
    read_modules_masses_from_file()
      |> Enum.map(&calculate_fuel_for/1)
      |> Enum.sum
  end

  def resolve_second_part() do
    read_modules_masses_from_file()
      |> Enum.map(&calculate_fuel_including_additional_for/1)
      |> Enum.sum
  end

  def calculate_fuel_for(mass) do
    mass
      |> Decimal.div(3)
      |> Decimal.round(0, :down) 
      |> Decimal.to_integer
      |> Kernel.-(2)
  end

  def calculate_fuel_including_additional_for(mass) do
    fuel = calculate_fuel_for(mass)
    if(fuel < 0) do
      0
    else
      fuel + calculate_fuel_including_additional_for(fuel)
    end
  end

  defp read_modules_masses_from_file do
    File.stream!("advent1.txt")
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(fn({n, _}) -> n end)
  end

end
