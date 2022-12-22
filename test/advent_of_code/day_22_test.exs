defmodule AdventOfCode.Day22Test do
  use ExUnit.Case

  import AdventOfCode.Day22

  @input "
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
"

  test "part1" do
    result = part1(@input)

    assert result == 6032
  end

  test "part2" do
    result = part2(@input)

    assert result == 5031
  end
end
