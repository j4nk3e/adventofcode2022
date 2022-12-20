defmodule Deque do
  defstruct [:v, :next, :prev]

  def to_list(m, i \\ 0) do
    [
      m[i].v
      | if m[i].next == 0 do
          []
        else
          to_list(m, m[i].next)
        end
    ]
  end

  def scan(_, i, 0), do: i
  def scan(m, i, n) when n > map_size(m), do: scan(m, i, rem(n, map_size(m)))
  def scan(m, i, n) when n > map_size(m) / 2, do: scan(m, m[i].prev, n + 1)
  def scan(m, i, n) when n < 0, do: scan(m, i, rem(n, map_size(m)) + map_size(m))
  def scan(m, i, n), do: scan(m, m[i].next, n - 1)

  def remove(m, i) do
    e = m[i]

    m
    |> Map.update!(e.prev, fn q -> %Deque{q | next: e.next} end)
    |> Map.update!(e.next, fn q -> %Deque{q | prev: e.prev} end)
    |> Map.delete(i)
  end

  def insert(m, prev, k, v) do
    next = m[prev].next

    m
    |> Map.update!(prev, fn q -> %Deque{q | next: k} end)
    |> Map.update!(next, fn q -> %Deque{q | prev: k} end)
    |> Map.put(k, %Deque{next: next, prev: prev, v: v})
  end
end

defmodule AdventOfCode.Day20 do
  import Deque

  def part1(args) do
    m = parse(args)
    s = map_size(m)

    for i <- 0..(s - 1), reduce: m do
      m ->
        e = m[i]
        m = remove(m, i)
        prev = scan(m, e.prev, e.v)
        insert(m, prev, i, e.v)
    end
    |> result()
  end

  def part2(args) do
    m =
      parse(args)
      |> Enum.map(fn {k, v} -> {k, %Deque{v | v: v.v * 811_589_153}} end)
      |> Map.new()

    s = map_size(m)

    for _ <- 1..10, i <- 0..(s - 1), reduce: m do
      m ->
        e = m[i]
        m = remove(m, i)
        prev = scan(m, e.prev, e.v)
        insert(m, prev, i, e.v)
    end
    |> result()
  end

  def result(m) do
    l = m |> to_list()
    s = map_size(m)
    i = Enum.find_index(l, fn e -> e == 0 end)
    a = Enum.at(l, rem(i + 1000, s))
    b = Enum.at(l, rem(i + 2000, s))
    c = Enum.at(l, rem(i + 3000, s))
    a + b + c
  end

  defp parse(args) do
    l =
      String.trim(args)
      |> String.split("\n")
      |> Enum.map(fn i -> String.trim(i) |> Integer.parse() |> elem(0) end)
      |> Enum.with_index()

    s = Enum.count(l)

    l
    |> Enum.map(fn {a, b} -> {b, %Deque{next: rem(b + 1, s), prev: rem(b + s - 1, s), v: a}} end)
    |> Map.new()
  end
end
