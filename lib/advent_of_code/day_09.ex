defmodule AdventOfCode.Day09 do
  def part1(args) do
    for m <- parse(args), reduce: {MapSet.new(), {0, 0}, {0, 0}} do
      {pos, head, tail} ->
        nhead = move(head, m)
        ntail = follow(nhead, tail)
        {MapSet.put(pos, ntail), nhead, ntail}
    end
    |> elem(0)
    |> MapSet.size()
  end

  def part2(args) do
    for m <- parse(args), reduce: {MapSet.new(), {0, 0}, List.duplicate({0, 0}, 9)} do
      {pos, head, tails} ->
        nhead = move(head, m)

        {ntails, last} =
          Enum.map_reduce(tails, nhead, fn t, h ->
            f = follow(h, t)
            {f, f}
          end)

        {MapSet.put(pos, last), nhead, ntails}
    end
    |> elem(0)
    |> MapSet.size()
  end

  defp move({x, y}, "R"), do: {x + 1, y}
  defp move({x, y}, "U"), do: {x, y - 1}
  defp move({x, y}, "L"), do: {x - 1, y}
  defp move({x, y}, "D"), do: {x, y + 1}

  defp follow({hx, hy}, {tx, ty}) when abs(hx - tx) <= 1 and abs(hy - ty) <= 1, do: {tx, ty}
  defp follow({hx, hy}, {tx, ty}), do: {tx + sign(hx, tx), ty + sign(hy, ty)}

  defp sign(a, b) when a > b, do: 1
  defp sign(a, b) when a < b, do: -1
  defp sign(_, _), do: 0

  defp parse(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn s -> String.split(s, " ") end)
    |> Enum.flat_map(fn [d, c] -> List.duplicate(d, Integer.parse(c) |> elem(0)) end)
  end
end
