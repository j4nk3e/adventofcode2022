defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  test "part1" do
    input = "0  2  7  0"
    result = part1(input)

    assert result == 5
  end

  test "part2" do
    input = "0  2  7  0"
    result = part2(input)

    assert result == 4
  end
end
