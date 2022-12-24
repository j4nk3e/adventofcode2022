defmodule AdventOfCode.Day24Test do
  use ExUnit.Case

  import AdventOfCode.Day24

  @input "
  #.######
  #>>.<^<#
  #.<..<<#
  #>v.><>#
  #<^v^^>#
  ######.#
  "

  test "part1" do
    result = part1(@input)

    assert result == 18
  end

  test "part2" do
    result = part2(@input)

    assert result == 54
  end
end
