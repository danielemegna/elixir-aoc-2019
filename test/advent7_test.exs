defmodule Advent7Test do
  use ExUnit.Case

  test "resolve level" do
    assert 43210 == Advent7.max_thruster_signal_for([3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0])
  end
end
