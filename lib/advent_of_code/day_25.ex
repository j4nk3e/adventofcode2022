defmodule AdventOfCode.Day25 do
  def part1(args) do
    s = parse(args) |> Enum.map(&from_snafu/1) |> Enum.sum()
    {s, to_snafu(s)}
  end

  defp from_snafu(l, acc \\ 0)
  defp from_snafu([], acc), do: acc
  defp from_snafu([h | tail], acc), do: from_snafu(tail, acc * 5 + h)

  defp to_snafu(i, acc \\ [])
  defp to_snafu(0, acc), do: acc |> to_string()

  defp to_snafu(i, acc) do
    case(rem(i, 5)) do
      0 -> to_snafu(div(i, 5), [?0 | acc])
      1 -> to_snafu(div(i, 5), [?1 | acc])
      2 -> to_snafu(div(i, 5), [?2 | acc])
      3 -> to_snafu(div(i, 5) + 1, [?= | acc])
      4 -> to_snafu(div(i, 5) + 1, [?- | acc])
    end
  end

  defp(parse(args)) do
    for l <- String.trim(args) |> String.split("\n") do
      String.trim(l)
      |> to_charlist()
      |> Enum.map(fn
        ?0 -> 0
        ?1 -> 1
        ?2 -> 2
        ?- -> -1
        ?= -> -2
      end)
    end
  end
end
