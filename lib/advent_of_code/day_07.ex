defmodule F do
  defstruct files: [], size: 0
end

defmodule AdventOfCode.Day07 do
  def part1(args) do
    args
    |> parse()
    |> dir_sizes()
    |> Enum.filter(fn s -> s <= 100_000 end)
    |> Enum.sum()
  end

  def part2(args) do
    l =
      args
      |> parse()
      |> dir_sizes()
      |> Enum.sort()

    missing = 30_000_000 - 70_000_000 + List.last(l)

    l
    |> Enum.drop_while(fn s -> s <= missing end)
    |> hd()
  end

  defp dir_sizes(%F{files: files, size: s}) do
    [
      s
      | files
        |> Enum.filter(fn f -> !Enum.empty?(f.files) end)
        |> Enum.flat_map(&dir_sizes/1)
    ]
  end

  defp parse(args) do
    args
    |> String.trim()
    |> String.split("\n")
    |> collect(nil)
    |> elem(1)
  end

  defp collect([], cwd), do: {[], cwd}
  defp collect(["$ cd /" | tail], nil), do: collect(tail, %F{})
  defp collect(["$ cd .." | tail], cwd), do: {tail, cwd}
  defp collect(["dir " <> _ | tail], cwd), do: collect(tail, cwd)
  defp collect(["$ ls" | tail], cwd), do: collect(tail, cwd)

  defp collect(["$ cd " <> _ | tail], cwd) do
    {tail, dir} = collect(tail, %F{})

    collect(tail, %F{
      files: [dir | cwd.files],
      size: cwd.size + dir.size
    })
  end

  defp collect([size | tail], cwd) do
    size = Integer.parse(size) |> elem(0)

    collect(tail, %F{
      files: [%F{size: size} | cwd.files],
      size: cwd.size + size
    })
  end
end
