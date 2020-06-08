defmodule Advent8Test do
  use ExUnit.Case

  test "image_from test" do
    actual = Advent8.image_from([1,2,3,4,5,6,7,8,9,0,1,2], 3, 2)

    expected = %Image{layers: [
      %Layer{rows: [
        [1,2,3],
        [4,5,6]
      ]},
      %Layer{rows: [
        [7,8,9],
        [0,1,2]
      ]}
    ]}
    assert actual === expected
  end

  test "resolve level" do
    assert 1330 === Advent8.resolve
  end
end
