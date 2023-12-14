defmodule Day7 do
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
        |> Enum.frequencies()
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
    |> Enum.sort(fn {lcards, _, ltype}, {rcards, _, rtype} ->
      if ltype == rtype do
        cards_better(lcards, rcards, :part_1)
      else
        ltype > rtype
      end
    end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.reverse()
    |> Enum.reduce({0, 1}, fn bid, {acc, multiplier} ->
      {acc + bid * multiplier, multiplier + 1}
    end)
    |> elem(0)
  end

  def part2(input) do
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
        |> Enum.frequencies()
        |> Enum.sort(fn {_, lfreq}, {_, rfreq} -> lfreq > rfreq end)

      freq_arr =
        case Enum.find(freq_arr, fn {card, _} -> card == "J" end) do
          nil ->
            freq_arr

          {_, 5} ->
            freq_arr

          {_, jfreq} ->
            Enum.reject(freq_arr, fn {card, _} -> card == "J" end)
            |> List.update_at(0, fn {card, freq} -> {card, freq + jfreq} end)
        end

      hand_type =
        case freq_arr |> Enum.map(&elem(&1, 1)) |> Enum.filter(&(&1 > 1)) do
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
      {lcards, _, ltype} = lhand
      {rcards, _, rtype} = rhand

      if ltype == rtype do
        cards_better(lcards, rcards, :part_2)
      else
        ltype > rtype
      end
    end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.reverse()
    |> Enum.reduce({0, 1}, fn bid, {acc, multiplier} ->
      {acc + bid * multiplier, multiplier + 1}
    end)
    |> elem(0)
  end

  def cards_better("", "", _), do: false

  @card_power_p1 "AKQJT98765432" |> String.split("", trim: true)
  def cards_better(lcards, rcards, :part_1) do
    lcard_idx = Enum.find_index(@card_power_p1, &(&1 == String.at(lcards, 0)))
    rcard_idx = Enum.find_index(@card_power_p1, &(&1 == String.at(rcards, 0)))

    if lcard_idx == rcard_idx do
      cards_better(String.slice(lcards, 1..-1), String.slice(rcards, 1..-1), :part_1)
    else
      lcard_idx < rcard_idx
    end
  end

  @card_power_p2 "AKQT98765432J" |> String.split("", trim: true)
  def cards_better(lcards, rcards, :part_2) do
    lcard_idx = Enum.find_index(@card_power_p2, &(&1 == String.at(lcards, 0)))
    rcard_idx = Enum.find_index(@card_power_p2, &(&1 == String.at(rcards, 0)))

    if lcard_idx == rcard_idx do
      cards_better(String.slice(lcards, 1..-1), String.slice(rcards, 1..-1), :part_2)
    else
      lcard_idx < rcard_idx
    end
  end
end
