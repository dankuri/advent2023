defmodule Day8 do
  def part1(input) do
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
end
