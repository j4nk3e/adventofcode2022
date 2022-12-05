defmodule AdventOfCode.Day05 do
  def part1(args) do
    {map, inst} = parse(args)

    for [n, from, to] <- inst, reduce: map do
      acc ->
        f = acc[from]
        m = Enum.take(f, n) |> Enum.reverse()

        acc
        |> Map.replace!(from, Enum.drop(f, n))
        |> Map.update!(to, fn l -> m ++ l end)
    end
    |> top_string()
  end

  def part2(args) do
    {map, inst} = parse(args)

    for [n, from, to] <- inst, reduce: map do
      acc ->
        f = acc[from]
        m = Enum.take(f, n)

        acc
        |> Map.replace!(from, Enum.drop(f, n))
        |> Map.update!(to, fn l -> m ++ l end)
    end
    |> top_string
  end

  defp top_string(map) do
    map
    |> Map.to_list()
    |> Enum.sort_by(fn {i, _} -> i end)
    |> Enum.map(fn {_, e} -> hd(e) end)
    |> Enum.join()
  end

  defp parse(args) do
    [stack, inst] = args |> String.split("\n\n")

    s =
      for l <- stack |> String.split("\n"), !String.starts_with?(l, " 1") do
        Regex.scan(~r/[(\w)]|\s{4}/, l)
        |> Enum.map(&hd/1)
      end
      |> Enum.reverse()

    len = s |> Enum.map(&Enum.count/1) |> Enum.max()

    map =
      List.duplicate([], len)
      |> Enum.with_index()
      |> Enum.map(fn {a, b} -> {b + 1, a} end)
      |> Map.new()

    map =
      for r <- s, reduce: map do
        map ->
          Enum.reduce(
            Enum.with_index(r),
            map,
            fn {c, i}, acc ->
              if String.starts_with?(c, " ") do
                acc
              else
                Map.update!(acc, i + 1, fn l -> [c | l] end)
              end
            end
          )
      end

    inst =
      for i <- inst |> String.trim() |> String.split("\n") do
        [_, a, b, c] = Regex.run(~r/move (\d+) from (\d+) to (\d+)/, i)
        [a, b, c] |> Enum.map(fn i -> Integer.parse(i) |> elem(0) end)
      end

    {map, inst}
  end
end
