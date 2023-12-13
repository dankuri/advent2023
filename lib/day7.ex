defmodule Day7 do
  @card_power_p1 "AKQJT98765432" |> String.split("", trim: true)

  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.map(fn hand_bid ->
      {List.first(hand_bid), List.last(hand_bid) |> String.to_integer()}
    end)
    |> Enum.map(fn {hand, bid} ->
      freq_arr =
        hand
        |> String.split("", trim: true)
        |> Enum.reduce(%{}, fn char, appear_map ->
          Map.update(appear_map, char, 1, &(&1 + 1))
        end)
        |> Map.values()
        |> Enum.filter(&(&1 > 1))
        |> Enum.sort(&(&1 > &2))

      hand_type =
        case freq_arr do
          [] -> 1
          [2] -> 2
          [2, 2] -> 3
          [3] -> 4
          [3, 2] -> 5
          [4] -> 6
          [5] -> 7
        end

      {hand, bid, hand_type}
    end)
    |> Enum.sort(fn lhand, rhand ->
      ltype = elem(lhand, 2)
      rtype = elem(rhand, 2)

      if ltype == rtype do
        cards_better(elem(lhand, 0), elem(rhand, 0))
      else
        ltype > rtype
      end
    end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.reverse()
    |> Enum.reduce({0, 1}, fn bid, {acc, multiplier} ->
      {acc + bid * multiplier, multiplier + 1}
    end)
    |> dbg()
  end

  def cards_better("", ""), do: false

  def cards_better(lcards, rcards) do
    lcard_idx = Enum.find_index(@card_power_p1, &(&1 == String.at(lcards, 0)))
    rcard_idx = Enum.find_index(@card_power_p1, &(&1 == String.at(rcards, 0)))

    if lcard_idx == rcard_idx do
      cards_better(String.slice(lcards, 1..-1), String.slice(rcards, 1..-1))
    else
      lcard_idx < rcard_idx
    end
  end
end
