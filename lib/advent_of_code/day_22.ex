defmodule AdventOfCode.Day22 do
  def part1(args) do
    {map, dir} = parse(args)

    start =
      map |> Map.keys() |> Enum.filter(fn {_, y} -> y == 0 end) |> Enum.min_by(fn {x, _} -> x end)

    for d <- dir, reduce: {start, 0} do
      {pos, facing} ->
        move(map, pos, facing, d)
    end
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
    to_string(map, {x, y}, facing)

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
    seg = div(max_x, 4) + 1

    s =
      case div(x, seg) do
        0 ->
          2

        1 ->
          3

        2 ->
          case div(y, seg) do
            0 -> 1
            1 -> 4
            2 -> 5
          end

        3 ->
          6
      end

    #  0123
    # 3    0
    # 2    1
    # 1    2
    # 0    3
    #  3210
    o =
      case f do
        0 -> rem(y, seg)
        1 -> seg - rem(x, seg)
        2 -> seg - rem(-y, seg)
        3 -> rem(x, seg)
      end

    IO.inspect({{x, y}, s, o, f})

    {ns, nf} =
      case {s, f} do
        {1, 0} -> {6, 2}
        {1, 2} -> {3, 1}
        {1, 3} -> {2, 2}
        {2, 1} -> {5, 3}
        {2, 2} -> {6, 3}
        {2, 3} -> {1, 1}
        {3, 1} -> {5, 0}
        {3, 3} -> {1, 0}
        {4, 0} -> {6, 1}
        {5, 1} -> {2, 3}
        {5, 2} -> {3, 3}
        {6, 0} -> {1, 2}
        {6, 1} -> {2, 0}
        {6, 3} -> {4, 2}
      end

    {sx, sy} =
      case ns do
        1 -> {2 * seg, 0}
        2 -> {0, seg}
        3 -> {seg, seg}
        4 -> {2 * seg, seg}
        5 -> {2 * seg, 2 * seg}
        6 -> {3 * seg, 2 * seg}
      end

    #  3210
    # 0    0
    # 1    1
    # 2    2
    # 3    3
    #  3210
    n =
      case nf do
        0 -> {sx, sy + o}
        1 -> {sx + seg - o - 1, sy}
        2 -> {sx + seg - 1, sy}
        3 -> {sx + seg - o - 1, sy + seg - 1}
      end

    to_string(map, n, nf)
    {n, nf}
  end

  defp to_string(map, pos, f) do
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
    |> score()
  end
end
