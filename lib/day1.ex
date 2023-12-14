defmodule Day1 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(&Enum.filter(&1, fn char -> Integer.parse(char) != :error end))
    |> Enum.map(&(List.first(&1) <> List.last(&1)))
    |> Enum.map(&(Integer.parse(&1) |> elem(0)))
    |> Enum.sum()
    |> IO.puts()
  end

  def part2(input) do
    wordToNumberMap = %{
      "one" => "1ne",
      "two" => "2wo",
      "three" => "3hree",
      "four" => "4our",
      "five" => "5ive",
      "six" => "6ix",
      "seven" => "7even",
      "eight" => "8ight",
      "nine" => "9ine"
    }

    input
    |> String.split("\n", trim: true)
    |> Enum.map(
      &String.replace(&1, Map.keys(wordToNumberMap), fn matched ->
        Map.get(wordToNumberMap, matched)
      end)
    )
    # don't judge me
    |> Enum.map(
      &String.replace(&1, Map.keys(wordToNumberMap), fn matched ->
        Map.get(wordToNumberMap, matched)
      end)
    )
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Enum.map(&Enum.filter(&1, fn char -> Integer.parse(char) != :error end))
    |> Enum.map(&(List.first(&1) <> List.last(&1)))
    |> Enum.map(&(Integer.parse(&1) |> elem(0)))
    |> Enum.sum()
    |> IO.puts()
  end
end
