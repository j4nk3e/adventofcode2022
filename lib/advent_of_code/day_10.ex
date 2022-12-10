defmodule AdventOfCode.Day10 do
  def part1(args) do
    for f <- parse(args) |> Enum.flat_map(& &1), reduce: {1, 1, 0} do
      {counter, register, acc} ->
        acc =
          if rem(counter, 40) == 20 do
            acc + register * counter
          else
            acc
          end

        r = f.(register)
        {counter + 1, r, acc}
    end
    |> elem(2)
  end

  def part2(args) do
    for f <- parse(args) |> Enum.flat_map(& &1), reduce: {0, 1, []} do
      {counter, register, acc} ->
        pos = rem(counter, 40)
        acc = [(register >= pos - 1 && register <= pos + 1 && ?#) || ?. | acc]
        r = f.(register)
        {counter + 1, r, acc}
    end
    |> elem(2)
    |> Enum.reverse()
    |> Enum.chunk_every(40)
    |> Enum.map(fn l -> to_string(l) <> "\n" end)
    |> Enum.join()
  end

  defp parse(args) do
    inst =
      args
      |> String.trim()
      |> String.split("\n")

    for i <- inst do
      cond do
        i == "noop" ->
          [& &1]

        ["addx", n] = String.split(i, " ") ->
          {n, _} = Integer.parse(n)
          [& &1, &(&1 + n)]
      end
    end
  end
end
