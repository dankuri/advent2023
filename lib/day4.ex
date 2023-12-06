defmodule Day4 do
  def part1 do
    IO.puts("Day 4 - Part 1")

    File.read!("inputs/day4.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ": ", trim: true))
    |> Enum.map(&List.last/1)
    |> Enum.map(fn card ->
      [winning_nums, have_numbers] =
        String.split(card, " | ", trim: true)
        |> Enum.map(&String.split(&1, " ", trim: true))

      case Enum.count(have_numbers, &Enum.member?(winning_nums, &1)) do
        num when num > 0 -> Integer.pow(2, num - 1)
        _ -> 0
      end
    end)
    |> Enum.sum()
    |> IO.puts()
  end

  def part2 do
    IO.puts("Day 4 - Part 2")
    IO.puts("TODO")
  end

  def run do
    part1()
    part2()
  end
end

Day4.run()
