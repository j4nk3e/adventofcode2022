defmodule AdventOfCode.Day13 do
  def part1(args) do
    parse(args)
    |> Enum.chunk_every(2)
    |> Enum.with_index(1)
    |> Enum.map(&sorted/1)
    |> Enum.sum()
  end

  def part2(args) do
    x = [[2]]
    y = [[6]]

    s = [x, y | parse(args)] |> Enum.sort(fn a, b -> sorted(a, b) == 1 end)
    (1 + Enum.find_index(s, &(&1 == x))) * (1 + Enum.find_index(s, &(&1 == y)))
  end

  defp sorted({[a, b], i}) do
    sorted(a, b) * i
  end

  defp sorted([], []), do: nil
  defp sorted(_, []), do: 0
  defp sorted([], _), do: 1
  defp sorted([x | ta], [x | tb]), do: sorted(ta, tb)

  defp sorted([a | ta], [b | tb]) when is_list(a) and is_list(b),
    do: sorted(a, b) || sorted(ta, tb)

  defp sorted([a | ta], [b | tb]) when is_list(a), do: sorted([a | ta], [[b] | tb])
  defp sorted([a | ta], [b | tb]) when is_list(b), do: sorted([[a] | ta], [b | tb])
  defp sorted([a | _], [b | _]) when a < b, do: 1
  defp sorted([a | _], [b | _]) when a > b, do: 0

  defp parse_list("", acc), do: acc

  defp parse_list(<<?,, tail::binary>>, acc), do: parse_list(tail, acc)

  defp parse_list(<<?[, tail::binary>>, acc) do
    {l, r} = parse_list(tail, [])
    parse_list(r, [l | acc])
  end

  defp parse_list(<<?], tail::binary>>, acc), do: {Enum.reverse(acc), tail}

  defp parse_list(i, acc) do
    {i, r} = parse_int(i, <<>>)
    parse_list(r, [i | acc])
  end

  defp parse_int(<<head, tail::binary>> = s, acc) do
    if head in ?0..?9 do
      parse_int(tail, acc <> <<head>>)
    else
      {i, _} = Integer.parse(acc)
      {i, s}
    end
  end

  defp parse(args) do
    l = args |> String.trim() |> String.split("\n\n")

    for s <- l, l = String.split(s, "\n"), s <- l do
      parse_list(String.trim(s), []) |> hd
      # lazy solution:
      # Code.eval_string(s) |> elem(0)
    end
  end
end
