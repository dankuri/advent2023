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

    # bruh this completes in 50 sec on my 2016 macbook pro...
    File.read!("inputs/day4.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.reduce({[], %{}}, fn [card_id, card_nums], {cards, matches_map} ->
      card_id = String.split(card_id, " ") |> List.last() |> String.to_integer()

      [winning_nums, have_nums] =
        String.split(card_nums, " | ") |> Enum.map(&String.split(&1, " ", trim: true))

      matches = Enum.count(have_nums, &Enum.member?(winning_nums, &1))
      {cards ++ [card_id], Map.put(matches_map, card_id, matches)}
    end)
    |> populate_copies()
    |> Enum.count()
    |> IO.puts()
  end

  def populate_copies({[], _}), do: []

  def populate_copies({cards, matches_map}) do
    {id, cards} = List.pop_at(cards, 0)

    matching_keys =
      Enum.filter(
        Map.keys(matches_map),
        &(id < &1 and &1 <= id + Map.get(matches_map, id))
      )

    [id] ++
      populate_copies({matching_keys, matches_map}) ++
      populate_copies({cards, matches_map})
  end

  def run do
    part1()
    part2()
  end
end

Day4.run()
