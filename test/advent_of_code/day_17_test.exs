defmodule AdventOfCode.Day17Test do
  use ExUnit.Case

  import AdventOfCode.Day17

  @input ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"

  test "part1" do
    result = part1(@input)

    assert result == 3068
  end

  test "part2" do
    result = part2(@input)

    assert result == 1_514_285_714_288
  end
end
