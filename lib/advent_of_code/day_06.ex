defmodule AdventOfCode.Day06 do
  def part1(args) do
    a =
      args
      |> String.split(~r/\s+/)
      |> Enum.filter(fn s -> s != "" end)
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(&elem(&1, 0))

    f(a, MapSet.new(), 0) |> elem(0)
  end

  defp f(a, s, i) do
    if MapSet.member?(s, a) do
      {i, a}
    else
      max = Enum.max(a)
      ind = Enum.find_index(a, fn q -> q == max end)
      c = Enum.count(a)

      l =
        List.replace_at(a, ind, 0)
        |> Enum.map(fn n -> n + div(max, c) end)

      r = rem(max, c)

      l =
        for {n, i} <- Enum.with_index(l) do
          if (i > ind && i <= ind + r) || i <= r - c + ind do
            n + 1
          else
            n
          end
        end

      f(l, MapSet.put(s, a), i + 1)
    end
  end

  def part2(args) do
    a =
      args
      |> String.split(~r/\s+/)
      |> Enum.filter(fn s -> s != "" end)
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(&elem(&1, 0))

    {_, x} = f(a, MapSet.new(), 0)
    f(x, MapSet.new(), 0) |> elem(0)
  end
end
