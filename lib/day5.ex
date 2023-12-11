defmodule Day5 do
  def part1(input) do
    IO.puts("Day 5 - Part 1")

    [seeds | maps] =
      input
      |> String.split("\n\n", trim: true)

    seeds =
      String.split(seeds, ": ")
      |> List.last()
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

    maps =
      Enum.map(maps, fn map ->
        String.split(map, "\n", trim: true)
        |> tl()
        |> Enum.map(fn ranges ->
          String.split(ranges)
          |> Enum.map(&String.to_integer(&1))
        end)
      end)

    Enum.map(seeds, fn seed ->
      Enum.reduce(maps, -1, fn map, num_acc ->
        num_acc = if num_acc == -1, do: seed, else: num_acc

        Enum.reduce_while(map, num_acc, fn range, num ->
          [dest, src, offset] = range

          if src <= num and num < src + offset do
            {:halt, num + (dest - src)}
          else
            {:cont, num}
          end
        end)
      end)
    end)
    |> Enum.min()
  end
end
