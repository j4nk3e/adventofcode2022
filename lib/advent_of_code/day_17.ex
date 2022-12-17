defmodule AdventOfCode.Day17 do
  @moduledoc """
  ```
  ####

  .#.
  ###
  .#.

  ..#
  ..#
  ###

  #
  #
  #
  #

  ##
  ##
  ```
  -> x ^ y
  """
  @tetros %{
    0 => [{2, 0}, {3, 0}, {4, 0}, {5, 0}],
    1 => [{3, 0}, {2, 1}, {3, 1}, {4, 1}, {3, 2}],
    2 => [{2, 0}, {3, 0}, {4, 0}, {4, 1}, {4, 2}],
    3 => [{2, 0}, {2, 1}, {2, 2}, {2, 3}],
    4 => [{2, 0}, {3, 0}, {2, 1}, {3, 1}]
  }

  def part1(args) do
    jet = parse(args) |> Enum.with_index() |> Enum.map(fn {e, i} -> {i, e} end) |> Map.new()

    max =
      step(MapSet.new(), 0, jet, 0, 2022)
      |> Enum.max_by(fn {_, y} -> y end)
      |> elem(1)

    max + 1
  end

  @w 7
  @h 4

  defp step(field, _ti, _jet, _ji, 0) do
    field
  end

  defp step(field, ti, jet, ji, count) do
    t = @tetros[ti]
    max = field |> Enum.max_by(fn {_, y} -> y end, fn -> {0, -1} end) |> elem(1)

    field =
      if rem(count, 100) == 0 do
        field |> MapSet.filter(fn {_, y} -> y > max - 100 end)
      else
        field
      end

    tetro = appear(max, t)
    {tetro, ji} = field |> move(tetro, jet, ji)

    tetro
    |> MapSet.new()
    |> MapSet.union(field)
    |> step(rem(ti + 1, map_size(@tetros)), jet, ji, count - 1)
  end

  defp move(field, tetro, jet, ji) do
    {field, tetro}

    j = jet[rem(ji, map_size(jet))]

    d =
      if j == ?< do
        -1
      else
        1
      end

    t = tetro |> Enum.map(fn {x, y} -> {x + d, y} end)

    t =
      if t |> Enum.any?(fn {x, _} = p -> x < 0 || x >= @w || MapSet.member?(field, p) end) do
        tetro
      else
        t
      end

    t_drop = t |> Enum.map(fn {x, y} -> {x, y - 1} end)

    if t_drop |> Enum.any?(fn {_, y} = p -> MapSet.member?(field, p) || y < 0 end) do
      {t, ji + 1}
    else
      move(field, t_drop, jet, ji + 1)
    end
  end

  defp appear(max, tetro) do
    tetro
    |> Enum.map(fn {x, y} -> {x, y + max + @h} end)
  end

  defp parse(args) do
    String.trim(args) |> to_charlist()
  end

  @n 1_000_000_000_000

  def part2(args) do
    jet = parse(args) |> Enum.with_index() |> Enum.map(fn {e, i} -> {i, e} end) |> Map.new()

    cycle(MapSet.new(), 0, jet, 0, 0, nil, nil, nil, nil, nil, [])
    |> round()
  end

  defp cycle(field, ti, jet, ji, count, a, b, c, d, e, l) do
    jc = map_size(jet)
    t = @tetros[ti]
    max = field |> Enum.max_by(fn {_, y} -> y end, fn -> {0, -1} end) |> elem(1)

    field =
      if rem(count, 100) == 0 do
        field |> MapSet.filter(fn {_, y} -> y > max - 100 end)
      else
        field
      end

    b =
      if a && rem(ji, jc) == elem(a, 2) && ti == elem(a, 1) do
        {count, ti, rem(ji, jc), max}
      else
        b
      end

    {d, e} =
      if !d && b do
        d = elem(b, 0) - elem(a, 0)
        e = elem(b, 3) - elem(a, 3)
        {d, e}
      else
        {d, e}
      end

    a =
      if !a && div(ji, jc) > 5 && count > 1000 do
        {count, ti, rem(ji, jc), max}
      else
        a
      end

    l =
      if d do
        x = (@n - count) / d * e + max + 1

        if abs(x - round(x)) < 0.0001 do
          [x | l]
        else
          l
        end
      else
        l
      end

    if Enum.count(l) > 1 do
      hd(l)
    else
      tetro = appear(max, t)
      {tetro, ji} = field |> move(tetro, jet, ji)

      tetro
      |> MapSet.new()
      |> MapSet.union(field)
      |> cycle(rem(ti + 1, map_size(@tetros)), jet, ji, count + 1, a, b, c, d, e, l)
    end
  end
end
