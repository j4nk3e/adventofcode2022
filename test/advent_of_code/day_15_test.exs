defmodule AdventOfCode.Day15Test do
  use ExUnit.Case

  import AdventOfCode.Day15

  @input "
  Sensor at x=2, y=18: closest beacon is at x=-2, y=15
  Sensor at x=9, y=16: closest beacon is at x=10, y=16
  Sensor at x=13, y=2: closest beacon is at x=15, y=3
  Sensor at x=12, y=14: closest beacon is at x=10, y=16
  Sensor at x=10, y=20: closest beacon is at x=10, y=16
  Sensor at x=14, y=17: closest beacon is at x=10, y=16
  Sensor at x=8, y=7: closest beacon is at x=2, y=10
  Sensor at x=2, y=0: closest beacon is at x=2, y=10
  Sensor at x=0, y=11: closest beacon is at x=2, y=10
  Sensor at x=20, y=14: closest beacon is at x=25, y=17
  Sensor at x=17, y=20: closest beacon is at x=21, y=22
  Sensor at x=16, y=7: closest beacon is at x=15, y=3
  Sensor at x=14, y=3: closest beacon is at x=15, y=3
  Sensor at x=20, y=1: closest beacon is at x=15, y=3
  "

  test "part1" do
    result = part1(@input, 10)

    assert result == 26
  end

  test "remove" do
    assert remove([{1, 9}, {99, 100}], {1, 9}) == [{99, 100}]
    assert remove([{1, 9}, {99, 100}], {0, 10}) == [{99, 100}]
    assert remove([{0, 9}, {99, 100}], {2, 9}) == [{0, 1}, {99, 100}]
    assert remove([{0, 9}, {99, 100}], {8, 9}) == [{0, 7}, {99, 100}]
    assert remove([{0, 9}, {99, 100}], {2, 8}) == [{0, 1}, {9, 9}, {99, 100}]
    assert remove([{0, 9}, {99, 100}], {9, 10}) == [{0, 8}, {99, 100}]
    assert remove([{0, 9}, {99, 100}], {0, 0}) == [{1, 9}, {99, 100}]

    assert remove([{1, 9}], {1, 1}) == [{2, 9}]
    assert remove([{1, 9}], {2, 2}) == [{1, 1}, {3, 9}]
    assert remove([{1, 9}], {9, 9}) == [{1, 8}]
  end

  test "part2" do
    result = part2(@input, 20)

    assert result == 56_000_011
  end
end
