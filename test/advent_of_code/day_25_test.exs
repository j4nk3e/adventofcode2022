defmodule AdventOfCode.Day25Test do
  use ExUnit.Case

  import AdventOfCode.Day25

  @input "
  1=-0-2
  12111
  2=0=
  21
  2=01
  111
  20012
  112
  1=-1=
  1-12
  12
  1=
  122
  "

  test "part1" do
    result = part1(@input)

    assert result == {4890, "2=-1=0"}
  end
end
