defmodule AdventOfCode.Day04 do
  def part1(args) do
    parse(args)
    |> Enum.count(fn p -> any(p, &contains/2) end)
  end

  def part2(args) do
    parse(args)
    |> Enum.count(fn p -> any(p, &overlaps/2) end)
  end

  defp any({m, n}, f), do: f.(m, n) || f.(n, m)
  defp contains({a, b}, m), do: between(a, m) && between(b, m)
  defp overlaps({a, b}, m), do: between(a, m) || between(b, m)
  defp between(i, {a, b}), do: i >= a && i <= b

  defp parse(args) do
    lines =
      args
      |> String.trim()
      |> String.split("\n")

    for l <- lines do
      [a, b, c, d] =
        Regex.run(~r/(\d+)-(\d+),(\d+)-(\d+)/, l)
        |> tl()
        |> Enum.map(&Integer.parse/1)
        |> Enum.map(&elem(&1, 0))

      {{a, b}, {c, d}}
    end
  end
end
