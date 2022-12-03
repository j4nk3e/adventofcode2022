defmodule AdventOfCode.Day03 do
  import MapSet

  def part1(args) do
    for l <- parse(args), len = String.length(l) do
      [a, b] =
        to_charlist(l)
        |> Enum.split(div(len, 2))
        |> Tuple.to_list()
        |> Enum.map(&MapSet.new/1)

      intersection(a, b) |> to_list |> hd |> cost
    end
    |> Enum.sum()
  end

  defp cost(c) when c < ?a, do: c - ?A + 27
  defp cost(c), do: c - ?a + 1

  defp parse(args), do: String.trim(args) |> String.split("\n")

  def part2(args) do
    groups =
      parse(args)
      |> Enum.map(&to_charlist/1)
      |> Enum.map(&MapSet.new/1)
      |> Enum.chunk_every(3)

    for [a, b, c] <- groups do
      intersection(a, b)
      |> intersection(c)
      |> to_list
      |> hd
      |> cost
    end
    |> Enum.sum()
  end
end
