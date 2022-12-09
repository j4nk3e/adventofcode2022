defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09

  @input """
  R 4
  U 4
  L 3
  D 1
  R 4
  D 1
  L 5
  R 2
  """

  test "part1" do
    result = part1(@input)

    assert result == 13
  end

  test "part2" do
    assert part2(@input) == 1

    assert part2("""
           R 5
           U 8
           L 8
           D 3
           R 17
           D 10
           L 25
           U 20
           """) == 36
  end
end
