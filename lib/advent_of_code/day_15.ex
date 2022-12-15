defmodule AdventOfCode.Day15 do
  def part1(args, y \\ 2_000_000) do
    grid = parse(args)

    for {{sx, sy}, {bx, by}} <- grid do
      d = abs(sx - bx) + abs(sy - by)
      q = d - abs(y - sy)

      if q < 0 do
        nil
      else
        (sx - q)..(sx + q - 1)
      end
    end
    |> Enum.filter(& &1)
    |> Enum.flat_map(& &1)
    |> Enum.uniq()
    |> Enum.count()
  end

  def remove([], _), do: []

  def remove([{l, r} = h | tail], {a, b}) do
    cond do
      b < l -> [h | tail]
      r < a -> [h | remove(tail, {a, b})]
      a <= l && b < r -> [{b + 1, r} | tail]
      a <= l && r <= b -> remove(tail, {a, b})
      l < a && b < r -> [{l, a - 1}, {b + 1, r} | tail]
      l < a && r <= b -> [{l, a - 1} | remove(tail, {a, b})]
    end
  end

  defp hole(_, y, max) when y > max, do: []

  defp hole(grid, y, max) do
    ranges =
      for {{sx, sy}, {bx, by}} <- grid, reduce: [{0, max}] do
        ranges ->
          d = abs(sx - bx) + abs(sy - by)
          q = d - abs(y - sy)

          if q < 0 do
            ranges
          else
            remove(ranges, {sx - q, sx + q})
          end
      end

    if Enum.empty?(ranges) do
      hole(grid, y + 1, max)
    else
      {ranges |> hd |> elem(0), y}
    end
  end

  def part2(args, max \\ 4_000_000) do
    grid = parse(args)

    {x, y} = hole(grid, 0, max)
    y + 4_000_000 * x
  end

  defp parse(args) do
    for l <- args |> String.trim() |> String.split("\n") do
      [sx, sy, bx, by] =
        Regex.run(
          ~r"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)",
          l,
          capture: :all_but_first
        )
        |> Enum.map(fn i -> Integer.parse(i) |> elem(0) end)

      {{sx, sy}, {bx, by}}
    end
  end
end
