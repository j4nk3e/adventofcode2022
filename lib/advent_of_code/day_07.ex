defmodule F do
  defstruct [:name, files: %{}, size: 0]
end

defmodule AdventOfCode.Day07 do
  def part1(args) do
    args
    |> parse()
    |> elem(1)
    |> dir_sizes()
    |> Enum.filter(fn s -> s <= 100_000 end)
    |> Enum.sum()
  end

  def part2(args) do
    l =
      args
      |> parse()
      |> elem(1)
      |> dir_sizes()
      |> Enum.sort()

    missing = 30_000_000 - 70_000_000 + List.last(l)

    l
    |> Enum.drop_while(fn s -> s <= missing end)
    |> hd
  end

  defp dir_sizes(%F{files: files, size: s}) do
    [
      s
      | files
        |> Map.values()
        |> Enum.filter(fn f -> !Enum.empty?(f.files) end)
        |> Enum.flat_map(&dir_sizes/1)
    ]
  end

  defp parse(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> collect(nil)
  end

  defp collect([], cwd), do: {[], cwd}
  defp collect(["$ cd /" | tail], nil), do: collect(tail, %F{name: "/"})

  defp collect([head | tail], cwd) do
    cond do
      head == "$ cd .." ->
        {tail, cwd}

      cd = Regex.run(~r"\$ cd ([./\w]+)", head) ->
        [_, name] = cd
        {tail, dir} = collect(tail, cwd.files[name])

        collect(tail, %F{
          name: cwd.name,
          files: Map.replace!(cwd.files, name, dir),
          size: cwd.size + dir.size
        })

      Regex.run(~r"\$ ls", head) ->
        {tail, files} = ls(tail, %{})

        collect(tail, %F{
          name: cwd.name,
          files: files,
          size:
            Enum.map(files, fn {_n, f} -> f.size end)
            |> Enum.sum()
            |> Kernel.+(cwd.size)
        })
    end
  end

  defp ls([], acc), do: {[], acc}

  defp ls([head | tail] = l, acc) do
    cond do
      file = Regex.run(~r/(\d+) ([\w.]+)/, head) ->
        [_, size, name] = file

        ls(
          tail,
          Map.put(acc, name, %F{
            name: name,
            size:
              Integer.parse(size)
              |> elem(0)
          })
        )

      dir = Regex.run(~r/dir ([\w.]+)/, head) ->
        [_, name] = dir
        ls(tail, Map.put(acc, name, %F{name: name}))

      true ->
        {l, acc}
    end
  end
end
