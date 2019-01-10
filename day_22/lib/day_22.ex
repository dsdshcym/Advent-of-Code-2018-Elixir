defmodule Day22 do
  def part_1(depth, target) do
    build_cave(depth, target)
    |> sum_of_risk_levels_in_rectangle()
  end

  def sum_of_risk_levels_in_rectangle(cave) do
    cave
    |> Map.values()
    |> Enum.map(&risk_level/1)
    |> Enum.sum()
  end

  def build_cave(depth, {max_x, max_y} = target) do
    for x <- 0..max_x,
        y <- 0..max_y,
        coordinates = {x, y},
        erosion_level = erosion_level(depth, coordinates, target),
        do: {coordinates, erosion_level},
        into: %{}
  end

  def risk_level(erosion_level) do
    risk_level_for_region_type(region_type(erosion_level))
  end

  def risk_level(depth, coordinates, target) do
    erosion_level(depth, coordinates, target)
    |> risk_level
  end

  defp risk_level_for_region_type(:rocky), do: 0
  defp risk_level_for_region_type(:wet), do: 1
  defp risk_level_for_region_type(:narrow), do: 2

  defp region_type(erosion_level) do
    case rem(erosion_level, 3) do
      0 -> :rocky
      1 -> :wet
      2 -> :narrow
    end
  end

  defp erosion_level(depth, coordinates, target) do
    rem(geologic_index(depth, coordinates, target) + depth, 20183)
  end

  defp geologic_index(_depth, {0, 0}, _target), do: 0
  defp geologic_index(_depth, coordinates, target) when coordinates == target, do: 0
  defp geologic_index(_depth, {x, 0}, _target), do: x * 16807
  defp geologic_index(_depth, {0, y}, _target), do: y * 48271

  defp geologic_index(depth, {x, y}, target),
    do: erosion_level(depth, {x - 1, y}, target) * erosion_level(depth, {x, y - 1}, target)
end
