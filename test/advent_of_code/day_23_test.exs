defmodule AdventOfCode.Day23Test do
  use ExUnit.Case

  import AdventOfCode.Day23

  @input "
....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#..
"

  test "part1" do
    result = part1(@input)

    assert result == 110
  end

  test "part2" do
    result = part2(@input)

    assert result == 20
  end
end
