defmodule Advent8Test do
  use ExUnit.Case

  test "image_from test" do
    actual = Advent8.image_from([1,2,3,4,5,6,7,8,9,0,1,2], 3, 2)

    expected = %Image{
      width: 3,
      height: 2,
      layers: [
        %Layer{rows: [
          [1,2,3],
          [4,5,6]
        ]},
        %Layer{rows: [
          [7,8,9],
          [0,1,2]
        ]}
      ]
    }
    assert actual === expected
  end

  test "resolve level (first part)" do
    assert 1330 === Advent8.resolve_first_part
  end

  test "merge_image_layers test" do
    source_image = %Image{
      width: 2,
      height: 2,
      layers: [
        %Layer{rows: [
          [0,2],
          [2,2]
        ]},
        %Layer{rows: [
          [1,1],
          [2,2]
        ]},
        %Layer{rows: [
          [2,2],
          [1,2]
        ]},
        %Layer{rows: [
          [0,0],
          [0,0]
        ]}
      ]
    }

    actual = Advent8.merge_image_layers(source_image)

    expected = %Image{
      width: 2,
      height: 2,
      layers: [
        %Layer{rows: [
          [0,1],
          [1,0]
        ]}
      ]
    }
    assert actual === expected
  end

  test "resolve level (second part)" do
    expected = "****  **  *  * **** **** \n"<>
               "*    *  * *  * *    *    \n"<>
               "***  *  * **** ***  ***  \n"<>
               "*    **** *  * *    *    \n"<>
               "*    *  * *  * *    *    \n"<>
               "*    *  * *  * **** *    "
    assert expected === Advent8.resolve_second_part
  end
end
