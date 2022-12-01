defmodule AdventOfCode.Day01 do
  def part1(args) do
    parse(args) |> Enum.max()
  end

  defp parse(args) do
    for d <- String.split(String.trim(args), "\n\n") do
      for b <- String.split(d, "\n") do
        Integer.parse(b) |> elem(0)
      end
      |> Enum.sum()
    end
  end

  defp replace_min([], _), do: []
  defp replace_min([h | t], min) when h > min, do: [h | replace_min(t, min)]
  defp replace_min([h | t], min), do: [min | replace_min(t, h)]

  def part2(args) do
    p = parse(args)

    for i <- Enum.drop(p, 3), reduce: Enum.take(p, 3) do
      acc -> replace_min(acc, i)
    end
    |> Enum.sum()
  end
end
