defmodule AdventOfCode.Day12 do
  def part1(args) do
    {grid, start, goal} = parse(args)
    dij(grid, %{start => ?a}, goal)
  end

  def part2(args) do
    {grid, _, goal} = parse(args)
    grid |> dij(Map.filter(grid, fn {_, h} -> h == ?a end), goal)
  end

  defp neighbors({x, y}), do: [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1}]

  defp dij(grid, starts, goal, steps \\ 1) do
    next =
      for {pos, h} <- starts, n <- neighbors(pos), nh = grid[n], nh - h <= 1 do
        {n, nh}
      end
      |> Map.new()

    (next[goal] && steps) || grid |> Map.drop(Map.keys(next)) |> dij(next, goal, steps + 1)
  end

  defp parse(args) do
    l = String.trim(args) |> String.split("\n") |> Enum.with_index()

    grid =
      for {r, y} <- l, r = String.trim(r) |> to_charlist |> Enum.with_index() do
        for {c, x} <- r do
          {{x, y}, c}
        end
      end
      |> Enum.flat_map(& &1)

    {start, _} = Enum.find(grid, fn {_, v} -> v == ?S end)
    {goal, _} = Enum.find(grid, fn {_, v} -> v == ?E end)

    grid =
      grid
      |> Map.new()
      |> Map.update!(goal, fn _ -> ?z end)
      |> Map.update!(start, fn _ -> ?a end)

    {grid, start, goal}
  end
end
