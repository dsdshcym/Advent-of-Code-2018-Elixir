defmodule Day22 do
  defmodule Cave do
    def create(depth, target) do
      %{
        erosion_levels: %{},
        depth: depth,
        target: target
      }
    end

    def find_or_insert_erosion_level(cave, coordinates) do
      case cave.erosion_levels do
        %{^coordinates => erosion_level} ->
          {cave, erosion_level}

        %{} ->
          {new_cave, geologic_index} = geologic_index(cave, coordinates)
          erosion_level = rem(geologic_index + cave.depth, 20183)
          new_cave = put_in(new_cave.erosion_levels[coordinates], erosion_level)

          {new_cave, erosion_level}
      end
    end

    def erosion_level(cave, coordinates) do
      case cave.erosion_levels do
        %{^coordinates => erosion_level} -> erosion_level
        %{} -> rem(geologic_index(cave, coordinates) + cave.depth, 20183)
      end
    end

    defp geologic_index(cave, {0, 0}), do: {cave, 0}

    defp geologic_index(%{target: target} = cave, coordinates) when coordinates == target,
      do: {cave, 0}

    defp geologic_index(cave, {x, 0}), do: {cave, x * 16807}
    defp geologic_index(cave, {0, y}), do: {cave, y * 48271}

    defp geologic_index(cave, {x, y}) do
      {cave, erosion_level_1} = find_or_insert_erosion_level(cave, {x - 1, y})
      {cave, erosion_level_2} = find_or_insert_erosion_level(cave, {x, y - 1})

      {cave, erosion_level_1 * erosion_level_2}
    end
  end

  def part_1(depth, target) do
    build_cave(depth, target)
    |> sum_of_risk_levels_in_rectangle()
  end

  def sum_of_risk_levels_in_rectangle(cave) do
    cave.erosion_levels
    |> Map.values()
    |> Enum.map(&risk_level/1)
    |> Enum.sum()
  end

  def build_cave(depth, {max_x, max_y} = target) do
    for x <- 0..max_x, y <- 0..max_y do
      {x, y}
    end
    |> Enum.reduce(
      Cave.create(depth, target),
      fn coordinates, cave ->
        {cave, _erosion_level} = Cave.find_or_insert_erosion_level(cave, coordinates)

        cave
      end
    )
  end

  def risk_level(erosion_level) do
    risk_level_for_region_type(region_type(erosion_level))
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
end
