defmodule AdventOfCode.Day24 do
  def part1(args) do
    {s, w, h} = parse(args)
    dijkstra({s, 0}, w, h, {w - 1, h}, MapSet.new([{0, -1}])) |> elem(1)
  end

  def part2(args) do
    {s, w, h} = parse(args)
    start = {0, -1}
    goal = {w - 1, h}

    {s, 0}
    |> dijkstra(w, h, goal, [start])
    |> dijkstra(w, h, start, [goal])
    |> dijkstra(w, h, goal, [start])
    |> elem(1)
  end

  defp dijkstra({s, count}, w, h, goal, pos) do
    n =
      for {x, y} <- pos,
          {x, y} <- [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}, {x, y}],
          (x >= 0 && y >= 0 && x < w && y < h) || {x, y} == {0, -1} || {x, y} == {w - 1, h},
          free?(s, x, y) do
        {x, y}
      end
      |> Enum.uniq()

    cond do
      Enum.member?(n, goal) -> {s, count}
      true -> dijkstra({step(s, w, h), count + 1}, w, h, goal, n)
    end
  end

  defp free?(s, x, y) do
    !(Map.get(s, {:u, x}, []) |> Enum.member?(y) ||
        Map.get(s, {:d, x}, []) |> Enum.member?(y) ||
        Map.get(s, {:l, y}, []) |> Enum.member?(x) ||
        Map.get(s, {:r, y}, []) |> Enum.member?(x))
  end

  defp step(s, w, h) do
    s
    |> Enum.map(fn
      {{:u, x}, l} -> {{:u, x}, Enum.map(l, fn e -> rem(e - 1 + h, h) end)}
      {{:d, x}, l} -> {{:d, x}, Enum.map(l, fn e -> rem(e + 1 + h, h) end)}
      {{:l, y}, l} -> {{:l, y}, Enum.map(l, fn e -> rem(e - 1 + w, w) end)}
      {{:r, y}, l} -> {{:r, y}, Enum.map(l, fn e -> rem(e + 1 + w, w) end)}
    end)
    |> Map.new()
  end

  defp parse(args) do
    for {row, y} <- String.trim(args) |> String.split("\n") |> Enum.with_index(-1),
        {c, x} <- String.trim(row) |> to_charlist |> Enum.with_index(-1),
        reduce: {%{}, 0, 0} do
      {acc, w, h} ->
        case c do
          ?^ -> {acc |> Map.update({:u, x}, [y], fn l -> [y | l] end), w, h}
          ?v -> {acc |> Map.update({:d, x}, [y], fn l -> [y | l] end), w, h}
          ?> -> {acc |> Map.update({:r, y}, [x], fn l -> [x | l] end), w, h}
          ?< -> {acc |> Map.update({:l, y}, [x], fn l -> [x | l] end), w, h}
          ?# -> {acc, max(w, x), max(h, y)}
          _ -> {acc, w, h}
        end
    end
  end
end
