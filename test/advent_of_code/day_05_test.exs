defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  @input """
  0
  3
  0
  1
  -3
  """

  test "part1" do
    result = part1(@input)

    assert result == 5
  end

  test "part2" do
    result = part2(@input)

    assert result == 10
  end
end
