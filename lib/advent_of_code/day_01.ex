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

  def part2(args) do
    for i <- parse(args), reduce: [] do
      acc ->
        cond do
          Enum.count(acc) < 3 ->
            [i | acc]

          Enum.all?(acc, fn e -> e > i end) ->
            acc

          true ->
            a = Enum.sort(acc) |> Enum.drop(1)
            [i | a]
        end
    end
    |> Enum.sum()
  end
end
