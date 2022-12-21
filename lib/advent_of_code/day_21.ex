defmodule AdventOfCode.Day21 do
  def part1(args) do
    m = parse(args)
    solve(m, m["root"])
  end

  defp parse(args) do
    for l <- String.trim(args) |> String.split("\n") do
      o1 = ~r"(\w+): (\w+) ([\+\-\*\/]) (\w+)"
      o2 = ~r"(\w+): (\d+)"
      r = Regex.run(o1, l)

      if r do
        [_, id, l, op, r] = r
        {id, {op, l, r}}
      else
        [_, id, n] = Regex.run(o2, l)
        n = Integer.parse(n) |> elem(0)
        {id, n}
      end
    end
    |> Map.new()
  end

  def part2(args) do
    m = parse(args)
    {_, l, r} = m["root"]

    if contains(m, l) do
      find(m, l, solve(m, m[r]))
    else
      find(m, r, solve(m, m[l]))
    end
  end

  defp find(_m, "humn", res), do: res
  defp find(m, k, res) when is_binary(k), do: find(m, m[k], res)

  defp find(m, {op, l, r}, res) do
    if contains(m, l) do
      case op do
        "+" -> find(m, l, res - solve(m, r))
        "*" -> find(m, l, div(res, solve(m, r)))
        "-" -> find(m, l, res + solve(m, r))
        "/" -> find(m, l, res * solve(m, r))
      end
    else
      case op do
        "+" -> find(m, r, res - solve(m, l))
        "*" -> find(m, r, div(res, solve(m, l)))
        "-" -> find(m, r, solve(m, l) - res)
        "/" -> find(m, r, div(solve(m, l), res))
      end
    end
  end

  defp solve(m, {op, l, r}) do
    f =
      case op do
        "*" -> &(&1 * &2)
        "/" -> &div(&1, &2)
        "+" -> &(&1 + &2)
        "-" -> &(&1 - &2)
      end

    f.(solve(m, m[l]), solve(m, m[r]))
  end

  defp solve(m, s) when is_binary(s), do: solve(m, m[s])
  defp solve(_m, n) when is_integer(n), do: n

  defp contains(_m, "humn"), do: true
  defp contains(_m, c) when is_integer(c), do: false
  defp contains(m, s) when is_binary(s), do: contains(m, m[s])
  defp contains(m, {_op, l, r}), do: contains(m, l) || contains(m, r)
end
