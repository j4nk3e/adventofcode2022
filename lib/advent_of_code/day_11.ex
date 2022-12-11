defmodule Monkee do
  use GenServer

  def start_link({id, start, op, test, div}) do
    {:ok, pid} =
      GenServer.start_link(__MODULE__, {start, op, test, div}, name: {:global, "m_#{id}"})

    pid
  end

  @impl true
  def init({items, op, test, div}) do
    state = {items, [], op, test, div, 0}
    {:ok, state}
  end

  @spec inspect(atom | pid | {atom, any} | {:via, atom, any}) :: any
  def inspect(pid) do
    GenServer.call(pid, :inspect)
  end

  def busy(pid) do
    GenServer.call(pid, :busy)
  end

  @impl true
  def handle_call(:inspect, _from, {items, inbox, op, test, div, busy}) do
    for i <- items ++ Enum.reverse(inbox) do
      i = op.(i)
      i = div.(i)
      next = test.(i)
      GenServer.call({:global, "m_#{next}"}, {:catch, i})
    end

    {:reply, :ok, {[], [], op, test, div, busy + Enum.count(items) + Enum.count(inbox)}}
  end

  @impl true
  def handle_call({:catch, item}, _from, {items, inbox, op, test, div, busy}) do
    state = {items, [item | inbox], op, test, div, busy}
    {:reply, :ok, state}
  end

  @impl true
  def handle_call(:busy, _from, {_, _, _, _, _, busy} = state) do
    {:reply, busy, state}
  end
end

defmodule AdventOfCode.Day11 do
  def part1(args) do
    monkees = parse(args)

    play(monkees, 20, &div(&1, 3))
  end

  def part2(args) do
    monkees = parse(args)

    div =
      Enum.map(monkees, fn m -> elem(m, 4) end)
      |> Enum.reduce(fn e, a -> e * a end)

    play(monkees, 10000, &rem(&1, div))
  end

  defp play(monkees, rounds, reduce) do
    m =
      for {id, start, op, test, _} <- monkees do
        Monkee.start_link({id, start, op, test, reduce})
      end

    for _ <- 1..rounds do
      for pid <- m do
        Monkee.inspect(pid)
      end
    end

    [a, b] =
      for pid <- m do
        Monkee.busy(pid)
      end
      |> Enum.sort(:desc)
      |> Enum.take(2)

    a * b
  end

  defp parse(args) do
    args
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&monkee/1)
  end

  defp monkee(s) do
    [id, start, op, test, if_true, if_false] = String.split(s, "\n")

    id = Regex.run(~r"(\d+)", id, capture: :all_but_first) |> hd |> Integer.parse() |> elem(0)

    start =
      Regex.scan(~r"(\d+)", start, capture: :all_but_first)
      |> Enum.map(fn e -> Integer.parse(hd(e)) |> elem(0) end)

    [a, op, b] = Regex.run(~r"new = ([\d\w]+) ([\+\*]) ([\d\w]+)", op, capture: :all_but_first)

    op =
      case op do
        "*" -> &(&1 * &2)
        "+" -> &(&1 + &2)
      end

    op = fn old ->
      a =
        if a == "old" do
          old
        else
          Integer.parse(a) |> elem(0)
        end

      b =
        if b == "old" do
          old
        else
          Integer.parse(b) |> elem(0)
        end

      op.(a, b)
    end

    prime =
      Regex.run(~r"(\d+)", test, capture: :all_but_first) |> hd |> Integer.parse() |> elem(0)

    if_true =
      Regex.run(~r"(\d+)", if_true, capture: :all_but_first) |> hd |> Integer.parse() |> elem(0)

    if_false =
      Regex.run(~r"(\d+)", if_false, capture: :all_but_first) |> hd |> Integer.parse() |> elem(0)

    test = fn i ->
      if rem(i, prime) == 0 do
        if_true
      else
        if_false
      end
    end

    {id, start, op, test, prime}
  end
end
