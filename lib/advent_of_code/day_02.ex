defmodule AdventOfCode.Day02 do
  def part1(args) do
    parse(args)
    |> Enum.map(fn [other, me] ->
      me + 1 +
        case rem(me - other + 3, 3) do
          0 -> 3
          1 -> 6
          2 -> 0
        end
    end)
    |> Enum.sum()
  end

  defp parse(args) do
    plays = args |> String.trim() |> String.split("\n")

    for p <- plays do
      String.split(p, " ")
      |> Enum.map(fn c ->
        cond do
          c == "A" || c == "X" -> 0
          c == "B" || c == "Y" -> 1
          c == "C" || c == "Z" -> 2
        end
      end)
    end
  end

  def part2(args) do
    parse(args)
    |> Enum.map(fn [other, me] ->
      rem(other + me - 1 + 3, 3) + 1 + me * 3
    end)
    |> Enum.sum()
  end
end
