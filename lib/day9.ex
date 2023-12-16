defmodule TreeNode do
  defstruct [:val, :left, :right]

  def new(right, left) when is_integer(right) and is_integer(left) do
    %__MODULE__{
      val: right - left,
      left: left,
      right: right
    }
  end

  def new(right, left) do
    %__MODULE__{
      val: right.val - left.val,
      left: left,
      right: right
    }
  end
end

defmodule Day9 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn line ->
      populate_to_zeroes(line) |> List.last() |> extrapolate(0) |> get_edge(:right)
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.map(fn line ->
      populate_to_zeroes(line) |> List.first() |> extrapolate_back(0) |> get_edge(:left)
    end)
    |> Enum.sum()
  end

  # maybe implementing Access protocol would help..
  def get_edge(%TreeNode{} = tree_node, :left), do: get_edge(tree_node.left, :left)
  def get_edge(%TreeNode{} = tree_node, :right), do: get_edge(tree_node.right, :right)
  def get_edge(num, _), do: num

  def populate_to_zeroes(line) do
    compare_fn =
      if Enum.all?(line, &is_map/1) do
        fn tree_node -> tree_node.val == 0 end
      else
        fn num -> num == 0 end
      end

    if Enum.all?(line, compare_fn) do
      line
    else
      line
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce([], fn [left, right], nodes ->
        [TreeNode.new(right, left) | nodes]
      end)
      |> Enum.reverse()
      |> populate_to_zeroes()
    end
  end

  def extrapolate(tree_node, prev_num) do
    if is_map(tree_node.right) do
      %TreeNode{
        val: prev_num + tree_node.val,
        left: tree_node.right,
        right: extrapolate(tree_node.right, tree_node.val + prev_num)
      }
    else
      %TreeNode{
        val: prev_num + tree_node.val,
        left: tree_node.right,
        right: tree_node.right + (tree_node.val + prev_num)
      }
    end
  end

  def extrapolate_back(tree_node, prev_num) do
    if is_map(tree_node.left) do
      %TreeNode{
        val: tree_node.val - prev_num,
        left: extrapolate_back(tree_node.left, tree_node.val - prev_num),
        right: tree_node.left
      }
    else
      %TreeNode{
        val: tree_node.val - prev_num,
        left: tree_node.left - (tree_node.val - prev_num),
        right: tree_node.left
      }
    end
  end
end
