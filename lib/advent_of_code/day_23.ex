defmodule AdventOfCode.Day23 do
  def part1(args) do
    set = parse(args)

    for i <- 1..10, reduce: set do
      acc -> step(acc, i)
    end
    |> score()
  end

  defp step(set, n) do
    set
    |> Enum.map(fn pos -> {pos, adjacent(set, pos)} end)
    |> Enum.group_by(
      fn {pos, adj} ->
        !Enum.empty?(adj) && Enum.find_value(n..(n + 3), &proppose(adj, pos, &1))
      end,
      fn {origin, _} -> origin end
    )
    |> Enum.flat_map(fn {target, origin} ->
      if target && Enum.count(origin) == 1 do
        [target]
      else
        origin
      end
    end)
    |> MapSet.new()
  end

  defp proppose(adj, {x, y}, o) do
    o = rem(o, 4)

    cond do
      o == 1 && Enum.filter(adj, fn {_, ny} -> ny < y end) |> Enum.empty?() -> {x, y - 1}
      o == 2 && Enum.filter(adj, fn {_, ny} -> ny > y end) |> Enum.empty?() -> {x, y + 1}
      o == 3 && Enum.filter(adj, fn {nx, _} -> nx < x end) |> Enum.empty?() -> {x - 1, y}
      o == 0 && Enum.filter(adj, fn {nx, _} -> nx > x end) |> Enum.empty?() -> {x + 1, y}
      true -> nil
    end
  end

  defp adjacent(set, {x, y}) do
    for dx <- -1..1, dy <- -1..1, dx != 0 || dy != 0, MapSet.member?(set, {x + dx, y + dy}) do
      {x + dx, y + dy}
    end
  end

  defp score(set) do
    {{min_x, _}, {max_x, _}} = set |> Enum.min_max_by(fn {x, _} -> x end)
    {{_, min_y}, {_, max_y}} = set |> Enum.min_max_by(fn {_, y} -> y end)
    (max_x - min_x + 1) * (max_y - min_y + 1) - MapSet.size(set)
  end

  defp parse(args) do
    for {r, y} <- String.trim(args) |> String.split("\n") |> Enum.with_index(),
        {c, x} <- to_charlist(r) |> Enum.with_index(),
        reduce: MapSet.new() do
      acc ->
        if c == ?# do
          MapSet.put(acc, {x, y})
        else
          acc
        end
    end
  end

  def part2(args) do
    set = parse(args)
    count(set, 1)
  end

  defp count(map, n) do
    next = step(map, n)

    if next == map do
      n
    else
      count(next, n + 1)
    end
  end
end
