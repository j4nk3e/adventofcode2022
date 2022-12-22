defmodule AdventOfCode.Day22 do
  def part1(args) do
    {map, dir} = parse(args)

    start =
      map |> Map.keys() |> Enum.filter(fn {_, y} -> y == 0 end) |> Enum.min_by(fn {x, _} -> x end)

    for d <- dir, reduce: {start, 0} do
      {pos, facing} ->
        move(map, pos, facing, d)
    end
    |> to_string(map)
    |> score()
  end

  defp score({{x, y}, f}) do
    (y + 1) * 1000 + (x + 1) * 4 + f
  end

  defp move(map, pos, facing, d, options \\ [])
  defp move(_map, pos, facing, 0, _), do: {pos, facing}
  defp move(_map, pos, facing, :left, _), do: {pos, rem(facing + 3, 4)}
  defp move(_map, pos, facing, :right, _), do: {pos, rem(facing + 1, 4)}

  defp move(map, {x, y}, facing, d, options) do
    #  to_string({{x, y}, facing}, map)

    {dx, dy} =
      case facing do
        0 -> {1, 0}
        1 -> {0, 1}
        2 -> {-1, 0}
        3 -> {0, -1}
      end

    {nx, ny} = {x + dx, y + dy}

    case map[{nx, ny}] do
      ?. ->
        move(map, {nx, ny}, facing, d - 1, options)

      ?# ->
        move(map, {x, y}, facing, 0, options)

      nil ->
        {n, f} =
          if :cube in options do
            wrap_cube(map, {x, y}, facing)
          else
            wrap(map, {x, y}, facing)
          end

        case map[n] do
          ?. -> move(map, n, f, d - 1, options)
          ?# -> move(map, {x, y}, facing, 0, options)
        end
    end
  end

  defp wrap(map, {x, y}, f) do
    k = Map.keys(map)

    p =
      case f do
        0 -> Enum.filter(k, fn {_, py} -> py == y end) |> Enum.min_by(fn {x, _} -> x end)
        1 -> Enum.filter(k, fn {px, _} -> px == x end) |> Enum.min_by(fn {_, y} -> y end)
        2 -> Enum.filter(k, fn {_, py} -> py == y end) |> Enum.max_by(fn {x, _} -> x end)
        3 -> Enum.filter(k, fn {px, _} -> px == x end) |> Enum.max_by(fn {_, y} -> y end)
      end

    {p, f}
  end

  defp wrap_cube(map, {x, y}, f) do
    k = Map.keys(map)
    {max_x, _} = k |> Enum.max_by(fn {x, _} -> x end)
    {_, max_y} = k |> Enum.max_by(fn {_, y} -> y end)
    seg = div(max_x + max_y + 2, 7)
    s = div(y, seg) * 4 + div(x, seg)

    o =
      if rem(f, 2) == 0 do
        rem(y, seg)
      else
        rem(x, seg)
      end

    {ns, nf, nx, ny} =
      if max_x + 1 == 4 * seg do
        case {s, f} do
          {2, 0} -> {11, 2, seg - 1, o}
          {2, 2} -> {5, 1, seg - 1 - o, 0}
          {2, 3} -> {4, 2, seg - 1, o}
          {4, 1} -> {10, 3, seg - o - 1, seg - 1}
          {4, 2} -> {11, 3, seg - o - 1, seg - 1}
          {4, 3} -> {2, 1, seg - 1 - o, 0}
          {5, 1} -> {10, 0, 0, o}
          {5, 3} -> {2, 0, 0, o}
          {6, 0} -> {11, 1, seg - 1 - o, 0}
          {10, 1} -> {4, 3, seg - o - 1, seg - 1}
          {10, 2} -> {5, 3, seg - o - 1, seg - 1}
          {11, 0} -> {2, 2, seg - 1, o}
          {11, 1} -> {4, 0, 0, o}
          {11, 3} -> {6, 2, seg - 1, o}
        end
      else
        case {s, f} do
          {1, 2} -> {8, 0, 0, seg - o - 1}
          {1, 3} -> {12, 0, 0, o}
          {2, 0} -> {9, 2, seg - 1, o}
          {2, 1} -> {5, 2, seg - 1, seg - o - 1}
          {2, 3} -> {12, 3, seg - o - 1, seg - 1}
          {5, 0} -> {2, 3, seg - o - 1, seg - 1}
          {5, 2} -> {8, 1, o, 0}
          {9, 0} -> {2, 2, seg - 1, o}
          {9, 1} -> {12, 2, seg - 1, seg - o - 1}
          {8, 2} -> {1, 0, 0, seg - o - 1}
          {8, 3} -> {5, 0, 0, o}
          {12, 0} -> {9, 3, seg - o - 1, seg - 1}
          {12, 1} -> {2, 1, o, 0}
          {12, 2} -> {1, 1, o, 0}
        end
      end

    {sx, sy} = {rem(ns, 4) * seg, div(ns, 4) * seg}

    {{sx + nx, sy + ny}, nf}
  end

  defp to_string({pos, f}, map) do
    {max_x, _} = map |> Map.keys() |> Enum.max_by(fn {x, _} -> x end)
    {_, max_y} = map |> Map.keys() |> Enum.max_by(fn {_, y} -> y end)

    for y <- 0..max_y do
      for x <- 0..max_x do
        m = map[{x, y}]

        cond do
          pos == {x, y} ->
            case f do
              0 -> ">"
              1 -> "v"
              2 -> "<"
              3 -> "^"
            end

          m == ?# ->
            "#"

          m == ?. ->
            "."

          true ->
            " "
        end
      end
      |> Enum.join()
    end
    |> Enum.map(&IO.puts/1)

    IO.puts("\n")
    {pos, f}
  end

  defp parse(args) do
    [map, dir] = args |> String.trim("\n") |> String.split("\n\n")

    map =
      for {l, y} <- String.split(map, "\n") |> Enum.with_index(),
          {c, x} <- to_charlist(l) |> Enum.with_index(),
          reduce: %{} do
        acc ->
          if c == ?\s do
            acc
          else
            Map.put(acc, {x, y}, c)
          end
      end

    dir =
      Regex.scan(~r"\d+|[RL]", dir, options: :all_but_first)
      |> Enum.map(fn
        ["R"] -> :right
        ["L"] -> :left
        [n] -> Integer.parse(n) |> elem(0)
      end)

    {map, dir}
  end

  def part2(args) do
    {map, dir} = parse(args)

    start =
      map |> Map.keys() |> Enum.filter(fn {_, y} -> y == 0 end) |> Enum.min_by(fn {x, _} -> x end)

    for d <- dir, reduce: {start, 0} do
      {pos, facing} ->
        move(map, pos, facing, d, [:cube])
    end
    |> to_string(map)
    |> score()
  end
end
