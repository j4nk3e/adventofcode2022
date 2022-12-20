defmodule AdventOfCode.Day20Test do
  use ExUnit.Case

  import AdventOfCode.Day20

  @input "
  1
  2
  -3
  3
  -2
  0
  4
  "

  test "part1" do
    result = part1(@input)

    assert result == 3
  end

  test "part2" do
    result = part2(@input)

    assert result == 1_623_178_306
  end
end
