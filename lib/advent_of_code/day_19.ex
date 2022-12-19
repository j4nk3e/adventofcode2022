defmodule BP do
  defstruct [:id, :ore, :clay, :obs_o, :obs_c, :geo_o, :geo_obs]
end

defmodule AdventOfCode.Day19 do
  def part1(args) do
    for bp <- args |> parse() do
      :ets.new(:d19, [:named_table, :set])
      r = (bp.id * best(bp, {1, 0, 0, 0}, {0, 0, 0, 0}, 24)) |> IO.inspect()
      :ets.delete(:d19)
      r
    end
    |> Enum.sum()
  end

  def part2(args) do
    for bp <- args |> parse() |> Enum.take(3) do
      :ets.new(:d19, [:named_table, :set])
      r = best(bp, {1, 0, 0, 0}, {0, 0, 0, 0}, 32) |> IO.inspect()
      :ets.delete(:d19)
      r
    end
    |> Enum.product()
  end

  defp build(bp, i, {o1, o2, o3, o4}) do
    case i do
      0 -> {o1, o2, o3, o4}
      1 -> {o1 - bp.ore, o2, o3, o4}
      2 -> {o1 - bp.clay, o2, o3, o4}
      3 -> {o1 - bp.obs_o, o2 - bp.obs_c, o3, o4}
      4 -> {o1 - bp.geo_o, o2, o3 - bp.geo_obs, o4}
    end
  end

  defp best(_, _, {_, _, _, g}, 0), do: g

  defp best(bp, {r1, r2, r3, r4} = r, {o1, o2, o3, _} = o, time) do
    s = :ets.lookup(:d19, {r, o, time})

    if s == [] do
      max =
        if o1 >= bp.geo_o && o3 >= bp.geo_obs do
          {o1, o2, o3, o4} = build(bp, 4, o)
          r = {r1, r2, r3, r4 + 1}
          o = {o1 + r1, o2 + r2, o3 + r3, o4 + r4}
          best(bp, r, o, time - 1)
        else
          for c <-
                [
                  0,
                  (o1 >= bp.ore && r4 == 0 && r3 == 0 &&
                     r1 < Enum.max([bp.ore, bp.clay, bp.obs_o, bp.geo_o]) && 1) || 0,
                  (o1 >= bp.clay && r4 == 0 && r2 < bp.obs_c && 2) || 0,
                  (o1 >= bp.obs_o && o2 >= bp.obs_c && r3 < bp.geo_obs && 3) || 0
                ]
                |> Enum.uniq() do
            {o1, o2, o3, o4} = build(bp, c, o)

            r = {
              r1 + ((c == 1 && 1) || 0),
              r2 + ((c == 2 && 1) || 0),
              r3 + ((c == 3 && 1) || 0),
              r4
            }

            o = {o1 + r1, o2 + r2, o3 + r3, o4 + r4}
            best(bp, r, o, time - 1)
          end
          |> Enum.max()
        end

      if time > 2 do
        :ets.insert(:d19, {{r, o, time}, max})
      end

      max
    else
      s |> hd |> elem(1)
    end
  end

  defp parse(args) do
    for bot <- String.trim(args) |> String.split("\n") do
      [id, ore, clay, obs_o, obs_c, geo_o, geo_obs] =
        Regex.scan(~r"(\d+)", bot, capture: :all_but_first)
        |> Enum.map(&hd/1)
        |> Enum.map(fn i -> Integer.parse(i) |> elem(0) end)

      %BP{
        id: id,
        ore: ore,
        clay: clay,
        obs_o: obs_o,
        obs_c: obs_c,
        geo_o: geo_o,
        geo_obs: geo_obs
      }
    end
  end
end
