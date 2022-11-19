defmodule AdventOfCode.Day05 do
  def part1(args) do
    array = parse(args)
    loop(array, fn v -> v + 1 end)
  end

  def part2(args) do
    array = parse(args)

    loop(array, fn v ->
      if v >= 3 do
        v - 1
      else
        v + 1
      end
    end)
  end

  defp parse(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
    |> :array.from_list()
  end

  defp loop(array, rule), do: loop(array, 0, :array.size(array), 0, rule)
  defp loop(_array, i, i, steps, _r), do: steps

  defp loop(array, pos, q, steps, rule) do
    v = :array.get(pos, array)
    loop(:array.set(pos, rule.(v), array), pos + v, q, steps + 1, rule)
  end
end
