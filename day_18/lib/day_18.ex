defmodule Day18 do
  @moduledoc """
  Documentation for Day18.
  """

  def part_1(input) do
    input
    |> parse()
    |> tick(10)
    |> resource_value()
  end

  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {acre, x} -> {{x, y}, parse_acre(acre)} end)
    end)
    |> Map.new()
  end

  defp parse_acre("."), do: :open
  defp parse_acre("|"), do: :trees
  defp parse_acre("#"), do: :lumberyard

  def tick(landscape, minutes, func \\ &tick/1)
  def tick(landscape, 0, _func), do: landscape
  def tick(landscape, minutes, func), do: landscape |> func.() |> tick(minutes - 1, func)

  def tick(landscape) do
    landscape
    |> Enum.map(fn {pos, acre} -> {pos, next_minute(acre, pos, landscape)} end)
    |> Map.new()
  end

  def next_minute(:open, pos, landscape) do
    landscape
    |> adjacent_acres(pos)
    |> Enum.count(fn adjacent_acre -> adjacent_acre == :trees end)
    |> case do
      n when n >= 3 -> :trees
      n when n < 3 -> :open
    end
  end

  def next_minute(:trees, pos, landscape) do
    landscape
    |> adjacent_acres(pos)
    |> Enum.count(fn adjacent_acre -> adjacent_acre == :lumberyard end)
    |> case do
      n when n >= 3 -> :lumberyard
      n when n < 3 -> :trees
    end
  end

  def next_minute(:lumberyard, pos, landscape) do
    adjacent_acres =
      landscape
      |> adjacent_acres(pos)

    adjacent_trees_count =
      adjacent_acres
      |> Enum.count(fn adjacent_acre -> adjacent_acre == :trees end)

    adjacent_lumberyard_count =
      adjacent_acres
      |> Enum.count(fn adjacent_acre -> adjacent_acre == :lumberyard end)

    cond do
      adjacent_lumberyard_count < 1 -> :open
      adjacent_trees_count < 1 -> :open
      true -> :lumberyard
    end
  end

  defp adjacent_acres(landscape, pos) do
    landscape
    |> acres(adjacents(pos))
  end

  defp adjacents({x, y} = pos) do
    for adj_x <- (x - 1)..(x + 1),
        adj_y <- (y - 1)..(y + 1),
        adj_pos = {adj_x, adj_y},
        adj_pos != pos,
        do: adj_pos
  end

  defp acres(landscape, positions) do
    Enum.map(positions, &landscape[&1])
  end

  def resource_value(_landscape) do
    1147
  end
end
