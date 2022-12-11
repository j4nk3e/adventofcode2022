defmodule Monkee do
  use GenServer
  defstruct id: nil, items: [], op: nil, prime: nil, throw: nil, reduce: nil, busy: 0

  def start_link(monkee) do
    {:ok, pid} =
      GenServer.start_link(__MODULE__, monkee,
        name: {:via, Registry, {AdventOfCode.Day11, monkee.id}}
      )

    pid
  end

  @impl true
  def init(monkee) do
    {:ok, {monkee, []}}
  end

  def inspect(pid) do
    GenServer.call(pid, :inspect)
  end

  def busy(pid) do
    GenServer.call(pid, :busy)
  end

  @impl true
  def handle_call(:inspect, _from, {monkee, inbox}) do
    for i <- monkee.items ++ Enum.reverse(inbox) do
      i = i |> monkee.op.() |> monkee.reduce.()
      {a, b} = monkee.throw

      next =
        case rem(i, monkee.prime) do
          0 -> a
          _ -> b
        end

      GenServer.call({:via, Registry, {AdventOfCode.Day11, next}}, {:catch, i})
    end

    {:reply, :ok,
     {%Monkee{
        monkee
        | busy: monkee.busy + Enum.count(monkee.items) + Enum.count(inbox),
          items: []
      }, []}}
  end

  @impl true
  def handle_call({:catch, item}, _from, {monkee, inbox}) do
    {:reply, :ok, {monkee, [item | inbox]}}
  end

  @impl true
  def handle_call(:busy, _from, {monkee, _} = state) do
    {:stop, :normal, monkee.busy, state}
  end
end

defmodule AdventOfCode.Day11 do
  def start() do
    Supervisor.start_link([{Registry, keys: :unique, name: __MODULE__}], strategy: :one_for_one)
  end

  def part1(args) do
    parse(args)
    |> play(20)
  end

  def part2(args) do
    monkees = parse(args)

    product =
      Enum.map(monkees, fn m -> m.prime end)
      |> Enum.reduce(fn e, a -> e * a end)

    monkees
    |> Enum.map(fn m -> %Monkee{m | reduce: &rem(&1, product)} end)
    |> play(10000)
  end

  defp play(monkees, rounds) do
    m =
      for m <- monkees do
        Monkee.start_link(m)
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

  defp numbers(s) do
    Regex.scan(~r"(\d+)", s, capture: :all_but_first)
    |> Enum.flat_map(& &1)
    |> Enum.map(fn e -> Integer.parse(e) |> elem(0) end)
  end

  defp old_or(i) do
    if i == "old" do
      & &1
    else
      n = Integer.parse(i) |> elem(0)
      fn _ -> n end
    end
  end

  defp monkee(s) do
    [id, start, op, prime, if_true, if_false] = String.split(s, "\n")
    start = numbers(start)
    [a, op, b] = Regex.run(~r"new = ([\d\w]+) ([\+\*]) ([\d\w]+)", op, capture: :all_but_first)

    [id, prime, if_true, if_false] =
      [id, prime, if_true, if_false] |> Enum.map(fn e -> numbers(e) |> hd end)

    op =
      case op do
        "*" -> &(&1 * &2)
        "+" -> &(&1 + &2)
      end

    a = old_or(a)
    b = old_or(b)
    op = fn old -> op.(a.(old), b.(old)) end

    %Monkee{
      id: id,
      items: start,
      op: op,
      prime: prime,
      reduce: &div(&1, 3),
      throw: {if_true, if_false}
    }
  end
end
