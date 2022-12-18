defmodule AdventOfCode.Day18 do
  def part1(args) do
    parse(args) |> surface() |> Enum.count()
  end

  def part2(args) do
    drop = parse(args)
    s = drop |> surface()

    max =
      0..2
      |> Enum.map(fn i -> (Enum.max_by(s, &elem(&1, i)) |> elem(i)) + 1 end)
      |> List.to_tuple()

    enclosed =
      s
      |> MapSet.new()
      |> explode(drop, MapSet.new(), MapSet.new([{0, 0, 0}]), max)

    s |> Enum.count(fn p -> !MapSet.member?(enclosed, p) end)
  end

  defp explode(cloud, drop, seen, start, {mx, my, mz} = max) do
    if Enum.empty?(start) do
      cloud
    else
      next =
        for {x, y, z} <- start,
            dir <- 0..2,
            off <- -1..1//2,
            x = (dir == 0 && x + off) || x,
            y = (dir == 1 && y + off) || y,
            z = (dir == 2 && z + off) || z,
            x >= -1 && x <= mx,
            y >= -1 && y <= my,
            z >= -1 && z <= mz,
            reduce: MapSet.new() do
          acc ->
            MapSet.put(acc, {x, y, z})
        end
        |> MapSet.difference(seen)
        |> MapSet.difference(drop)

      MapSet.difference(cloud, next)
      |> explode(drop, MapSet.union(seen, next), next, max)
    end
  end

  defp surface(grid) do
    for {x, y, z} <- grid, dir <- 0..2, off <- -1..1//2, reduce: [] do
      acc ->
        pos =
          [x, y, z]
          |> Enum.with_index()
          |> Enum.map(fn {c, i} ->
            if dir == i do
              c + off
            else
              c
            end
          end)
          |> List.to_tuple()

        if MapSet.member?(grid, pos) do
          acc
        else
          [pos | acc]
        end
    end
  end

  defp parse(args) do
    for l <- args |> String.trim() |> String.split("\n") do
      [x, y, z] =
        String.trim(l)
        |> String.split(",")
        |> Enum.map(&Integer.parse/1)
        |> Enum.map(&elem(&1, 0))

      {x, y, z}
    end
    |> MapSet.new()
  end
end
