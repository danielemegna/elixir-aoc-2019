defmodule Advent1Test do
  use ExUnit.Case

  test "calc test" do
    assert Advent1.calc(12) == 2
    assert Advent1.calc(14) == 2
    assert Advent1.calc(1969) == 654
    assert Advent1.calc(100756) == 33583
  end

  test "resolve level" do
    assert Advent1.resolve == 3262358
  end

end
