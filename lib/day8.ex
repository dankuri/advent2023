defmodule Day8 do
  def part1(input) do
    {dirs, map} = parse_input(input)

    find_zzz(dirs, map, "AAA", 0)
  end

  def find_zzz(dirs, map, cur_point, step_count) do
    next_dir = Enum.at(dirs, rem(step_count, Enum.count(dirs)))
    next_point = map[cur_point][next_dir]

    if next_point === "ZZZ" do
      step_count + 1
    else
      find_zzz(dirs, map, next_point, step_count + 1)
    end
  end

  def part2(input) do
    {dirs, map} = parse_input(input)

    map
    |> Map.keys()
    |> Enum.filter(&String.ends_with?(&1, "A"))
    |> Enum.map(&find_last_z(dirs, map, &1, 0))
    # lcm trick I just learned - thnx to Elixir Forum
    |> Enum.reduce(fn x, y -> div(x * y, Integer.gcd(x, y)) end)
  end

  def find_last_z(dirs, map, cur_point, step_count) do
    next_dir = Enum.at(dirs, rem(step_count, Enum.count(dirs)))
    next_point = map[cur_point][next_dir]

    if String.ends_with?(next_point, "Z") do
      step_count + 1
    else
      find_last_z(dirs, map, next_point, step_count + 1)
    end
  end

  def parse_input(input) do
    [dirs | points] =
      input
      |> String.split("\n", trim: true)

    dirs =
      String.split(dirs, "", trim: true)
      |> Enum.map(fn dir ->
        case dir do
          "L" -> :left
          "R" -> :right
        end
      end)

    map =
      points
      |> Enum.reduce(%{}, fn point, points_map ->
        [label, left_right] = String.split(point, " = ")
        [left, right] = String.slice(left_right, 1..-2) |> String.split(", ")
        Map.put(points_map, label, %{left: left, right: right})
      end)

    {dirs, map}
  end
end
