defmodule Day22 do
  defmodule Cave do
    use GenServer

    # Client

    def create(depth, target) do
      {:ok, cave} = GenServer.start_link(__MODULE__, %{depth: depth, target: target})

      cave
    end

    def risk_level(cave, coordinates) do
      cave
      |> region_type(coordinates)
      |> risk_level_for_region_type()
    end

    def region_type(cave, coordinates) do
      GenServer.call(cave, {:region_type, coordinates})
    end

    # Server

    def init(%{depth: depth, target: target}) do
      {:ok,
       %{
         erosion_levels: %{},
         depth: depth,
         target: target
       }}
    end

    def handle_call({:region_type, {x, y}}, _from, cave) when x < 0 or y < 0 do
      {:reply, :solid_rock, cave}
    end

    def handle_call({:region_type, coordinates}, _from, cave) do
      {new_cave, erosion_level} = erosion_level(cave, coordinates)

      region_type =
        erosion_level
        |> region_type()

      {:reply, region_type, new_cave}
    end

    defp erosion_level(cave, coordinates) do
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

    defp geologic_index(cave, {0, 0}), do: {cave, 0}

    defp geologic_index(%{target: target} = cave, coordinates) when coordinates == target,
      do: {cave, 0}

    defp geologic_index(cave, {x, 0}), do: {cave, x * 16807}
    defp geologic_index(cave, {0, y}), do: {cave, y * 48271}

    defp geologic_index(cave, {x, y}) do
      {cave, erosion_level_1} = erosion_level(cave, {x - 1, y})
      {cave, erosion_level_2} = erosion_level(cave, {x, y - 1})

      {cave, erosion_level_1 * erosion_level_2}
    end
  end

  def part_1(depth, {max_x, max_y} = target) do
    cave = Cave.create(depth, target)

    for x <- 0..max_x, y <- 0..max_y do
      Cave.risk_level(cave, {x, y})
    end
    |> Enum.sum()
  end
end
