defmodule AdventOfCode.Day14 do
  @o {500, 0}

  def part1(args) do
    grid = parse(args)
    max = grid |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()
    drop(grid, max, true, 0)
  end

  def part2(args) do
    grid = parse(args)
    max = grid |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()
    drop(grid, max + 1, false, 0)
  end

  defp drop(grid, max, inf, count) do
    {x, y} = drop(grid, max, @o)

    cond do
      y == max && inf -> count
      {x, y} == @o -> count + 1
      true -> drop(Map.put(grid, {x, y}, ?o), max, inf, count + 1)
    end
  end

  defp drop(_, max, {x, max}), do: {x, max}

  defp drop(grid, max, {x, y} = pos) do
    b = {x, y + 1}
    bl = {x - 1, y + 1}
    br = {x + 1, y + 1}

    cond do
      !grid[b] -> drop(grid, max, b)
      !grid[bl] -> drop(grid, max, bl)
      !grid[br] -> drop(grid, max, br)
      true -> pos
    end
  end

  defp parse(args) do
    lines = args |> String.trim() |> String.split("\n")

    for l <- lines, reduce: %{} do
      acc ->
        coords =
          String.split(l, " -> ")
          |> Enum.map(fn s ->
            String.split(s, ",")
            |> Enum.map(fn i -> String.trim(i) |> Integer.parse() |> elem(0) end)
          end)

        m =
          for {[x1, y1], [x2, y2]} <- Enum.zip(coords, tl(coords)),
              x <- x1..x2,
              y <- y1..y2,
              reduce: %{} do
            acc -> Map.put(acc, {x, y}, ?#)
          end

        Map.merge(acc, m)
    end
  end
end
