defmodule Advent4Test do
  use ExUnit.Case

  test "password meets_first_part_criteria? test" do
    assert true == Advent4.meets_first_part_criteria?(122456)
    assert true == Advent4.meets_first_part_criteria?(111122)
    assert true == Advent4.meets_first_part_criteria?(122333)
    assert true == Advent4.meets_first_part_criteria?(112222)
    assert true == Advent4.meets_first_part_criteria?(111111)
    assert true == Advent4.meets_first_part_criteria?(123444)
    assert true == Advent4.meets_first_part_criteria?(111234)
    assert true == Advent4.meets_first_part_criteria?(122234)
    assert false == Advent4.meets_first_part_criteria?(223450)
    assert false == Advent4.meets_first_part_criteria?(123789)
    assert false == Advent4.meets_first_part_criteria?(113734)
  end

  @tag :skip
  test "resolve level (first part)" do
    assert 1640 == Advent4.resolve_first_part
  end

  test "password meets_second_part_criteria? test" do
    assert true == Advent4.meets_second_part_criteria?(122456)
    assert true == Advent4.meets_second_part_criteria?(111122)
    #assert false == Advent4.meets_second_part_criteria?(111123)
    #assert true == Advent4.meets_second_part_criteria?(144422)
    assert false == Advent4.meets_second_part_criteria?(011123)
    assert true == Advent4.meets_second_part_criteria?(123345)
    assert true == Advent4.meets_second_part_criteria?(112222)
    assert false == Advent4.meets_second_part_criteria?(111222)
    assert false == Advent4.meets_second_part_criteria?(111111)
    assert false == Advent4.meets_second_part_criteria?(123444)
    assert false == Advent4.meets_second_part_criteria?(111234)
    assert false == Advent4.meets_second_part_criteria?(122234)
    assert false == Advent4.meets_second_part_criteria?(223450)
    assert false == Advent4.meets_second_part_criteria?(123789)
    assert false == Advent4.meets_second_part_criteria?(113734)
  end

  @tag :skip
  test "resolve level (second part)" do
    assert 1070 != Advent4.resolve_second_part
  end

end
