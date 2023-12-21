defmodule Day4 do
  def part1(input) do
    input
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

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.reduce(%{}, fn [card_id, card_nums], matches_map ->
      card_id = String.split(card_id, " ") |> List.last() |> String.to_integer()

      [winning_nums, have_nums] =
        String.split(card_nums, " | ") |> Enum.map(&String.split(&1, " ", trim: true))

      matches = Enum.count(have_nums, &Enum.member?(winning_nums, &1))
      Map.put(matches_map, card_id, matches)
    end)
    |> then(fn matches_map ->
      len = Map.keys(matches_map) |> Enum.count()

      Enum.reduce(Map.keys(matches_map) |> Enum.sort(), List.duplicate(1, len), fn num, occurs ->
        score = Map.get(matches_map, num)
        card_count = Enum.at(occurs, num - 1)

        if score < 1 do
          occurs
        else
          num..min(num + score - 1, len)
          |> Enum.reduce(occurs, fn next_num, new_occurs ->
            List.update_at(new_occurs, next_num, &(&1 + card_count))
          end)
        end
      end)
    end)
    |> Enum.sum()
    |> IO.puts()
  end
end
