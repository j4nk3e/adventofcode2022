defmodule AdventOfCode.Day16 do
  def part1(args) do
    m = parse(args) |> Map.new()
    start = "AA"

    cand =
      Enum.filter(m, fn {id, {flow, _}} -> flow > 0 || id == start end)
      |> Map.new()

    dist =
      for {c, _} <- cand, {t, _} <- cand, t != c do
        {{c, t}, dist(m, [c], t)}
      end
      |> Map.new()

    find(cand |> Map.delete(start), dist, start, 30, 0, 0)
  end

  defp find(m, _, _, time, flow, press) when map_size(m) == 0, do: time * flow + press

  defp find(next, dist, pos, time, flow, press) do
    for {n, {f, _}} <- next do
      d = dist[{pos, n}] + 1

      if d > time do
        find(%{}, dist, n, time, flow, press)
      else
        find(Map.delete(next, n), dist, n, time - d, flow + f, press + flow * d)
      end
    end
    |> Enum.max()
  end

  defp dist(map, start, goal, n \\ 0) do
    if Enum.find(start, &(&1 == goal)) do
      n
    else
      next =
        start
        |> Enum.map(fn t -> map[t] end)
        |> Enum.flat_map(fn {_, t} -> t end)
        |> Enum.uniq()

      dist(map, next, goal, n + 1)
    end
  end

  defp parse(args) do
    for l <- args |> String.trim() |> String.split("\n") do
      [_, valve, flow, targets] =
        Regex.run(~r"Valve (.*) has flow rate=(\d+); tunnels? leads? to valves? (.*)", l)

      {f, _} = Integer.parse(flow)
      t = String.split(targets, ", ", trim: true)
      {valve, {f, t}}
    end
  end

  def part2(args) do
    m = parse(args) |> Map.new()
    start = "AA"

    cand =
      Enum.filter(m, fn {id, {flow, _}} -> flow > 0 || id == start end)
      |> Map.new()

    dist =
      for {c, _} <- cand, {t, _} <- cand, t != c do
        {{c, t}, dist(m, [c], t)}
      end
      |> Map.new()

    cand
    |> Map.delete(start)
    |> find2(dist, start, 26, 0, 0, 0)
  end

  defp find2(m, _, _, time, flow, press, _) when map_size(m) == 0,
    do: time * flow + press

  defp find2(next, dist, pos, time, flow, press, i) do
    for {n, {f, _}} <- next do
      d = dist[{pos, n}] + 1

      if d > time do
        if i == 0 do
          time * flow + press + find2(next, dist, "AA", 26, 0, 0, 1)
        else
          find2(%{}, dist, n, time, flow, press, i)
        end
      else
        find2(Map.delete(next, n), dist, n, time - d, flow + f, press + flow * d, i)
      end
    end
    |> Enum.max()
  end
end
