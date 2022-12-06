defmodule AdventOfCode.Day06 do
  def part1(args), do: args |> marker(4)
  def part2(args), do: args |> marker(14)

  defp marker(chars, max, map \\ %{}, total \\ 0)
  defp marker(_, max, map, total) when map_size(map) == max, do: total

  defp marker(<<hd::utf8, tl::binary>>, max, map, total) do
    {n, map} = Map.get_and_update(map, hd, fn c -> {c, total} end)

    if n do
      marker(tl, max, Map.filter(map, fn {_, v} -> v > n end), total + 1)
    else
      marker(tl, max, map, total + 1)
    end
  end
end
