defmodule Advent1Test do
  use ExUnit.Case

  test "calculate_fuel_for function test" do
    assert Advent1.calculate_fuel_for(12) == 2
    assert Advent1.calculate_fuel_for(14) == 2
    assert Advent1.calculate_fuel_for(1969) == 654
    assert Advent1.calculate_fuel_for(100756) == 33583
  end

  test "resolve level (first part)" do
    assert Advent1.resolve_first_part == 3262358
  end

  test "calculate_fuel_including_additional_for function test" do
    assert Advent1.calculate_fuel_including_additional_for(14) == 2
    assert Advent1.calculate_fuel_including_additional_for(1969) == 966
    assert Advent1.calculate_fuel_including_additional_for(100756) == 50346
  end

  test "resolve level (second part)" do
    assert Advent1.resolve_second_part == 4890696
  end

end
