defmodule Day2 do
  def part1 do
    IO.puts("Day 2 - Part 1")

    max_cubes = %{
      "red" => 12,
      "green" => 13,
      "blue" => 14
    }

    File.read!("inputs/day2.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.filter(fn [_game, cubes] ->
      String.replace(cubes, ";", ",")
      |> String.split(", ")
      |> Enum.all?(fn cube ->
        [count, color] = String.split(cube)
        String.to_integer(count) <= max_cubes[color]
      end)
    end)
    |> Enum.map(fn [game, _cubes] ->
      [_, id] = String.split(game)
      String.to_integer(id)
    end)
    |> Enum.sum()
    |> IO.puts()
  end

  def part2 do
    IO.puts("Day 2 - Part 2")

    File.read!("inputs/day2.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [_, cubes] ->
      String.replace(cubes, ";", ",")
      |> String.split(", ")
      |> Enum.reduce(%{:red => 0, :green => 0, :blue => 0}, fn cube, cubes_max ->
        [count, color] = String.split(cube)
        count = String.to_integer(count)
        color = String.to_atom(color)

        Map.update(cubes_max, color, count, fn prev -> max(count, prev) end)
      end)
      |> Map.values()
      |> Enum.reduce(1, fn num, acc -> num * acc end)
    end)
    |> Enum.sum()
    |> IO.puts()
  end

  def run do
    part1()
    part2()
  end
end

Day2.run()
