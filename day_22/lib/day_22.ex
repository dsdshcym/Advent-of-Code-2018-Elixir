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

  def part_2(depth, target) do
    cave = Cave.create(depth, target)

    climber = %{
      tool: :torch,
      coordinates: {0, 0}
    }

    search(cave, climber, target)
  end

  defp search(cave, init_climber, target) do
    bfs_search(cave, [{0, MapSet.new([init_climber])}], target, MapSet.new())
  end

  defp bfs_search(cave, [{current_minute, current_climbers} | tail], target, visited) do
    climbers_at_target =
      current_climbers
      |> Enum.filter(&(&1.coordinates == target))

    case climbers_at_target do
      [] ->
        visited = MapSet.union(visited, current_climbers)

        next_climbers_by_minute =
          current_climbers
          |> Enum.flat_map(fn climber ->
            climber
            |> climb(cave)
            |> Enum.map(fn {time_cost, next_climber} ->
              {current_minute + time_cost, next_climber}
            end)
          end)
          |> Enum.reject(fn {minute, climber} -> climber in visited end)

        new_climbers_by_minute_queue =
          next_climbers_by_minute
          |> Enum.reduce(tail, &insert_into_queue/2)

        bfs_search(cave, new_climbers_by_minute_queue, target, visited)

      [climber | _] ->
        if climber.tool == :torch do
          current_minute
        else
          current_minute + 7
        end
    end
  end

  defp climb(climber, cave) do
    climber
    |> adjacent_regions()
    |> Enum.map(&climb_to(climber, &1, cave))
    |> Enum.filter(&(&1 != nil))
  end

  defp adjacent_regions(%{coordinates: {x, y}}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
  end

  defp climb_to(climber, to, cave) when is_tuple(to) do
    from_region = Cave.region_type(cave, climber.coordinates)
    to_region = Cave.region_type(cave, to)

    if to_region == :solid_rock do
      nil
    else
      case {from_region, to_region, climber.tool} do
        {:rocky, :wet, :climbing_gear} ->
          {1, %{climber | coordinates: to}}

        {:rocky, :wet, :torch} ->
          {8, %{climber | tool: :climbing_gear, coordinates: to}}

        {:rocky, :narrow, :climbing_gear} ->
          {8, %{climber | tool: :torch, coordinates: to}}

        {:rocky, :narrow, :torch} ->
          {1, %{climber | coordinates: to}}

        {:wet, :rocky, :climbing_gear} ->
          {1, %{climber | coordinates: to}}

        {:wet, :rocky, :neither} ->
          {8, %{climber | tool: :climbing_gear, coordinates: to}}

        {:wet, :narrow, :climbing_gear} ->
          {8, %{climber | tool: :neither, coordinates: to}}

        {:wet, :narrow, :neither} ->
          {1, %{climber | coordinates: to}}

        {:narrow, :rocky, :torch} ->
          {1, %{climber | coordinates: to}}

        {:narrow, :rocky, :neither} ->
          {8, %{climber | tool: :torch, coordinates: to}}

        {:narrow, :wet, :torch} ->
          {8, %{climber | tool: :neither, coordinates: to}}

        {:narrow, :wet, :neither} ->
          {1, %{climber | coordinates: to}}

        {from_region, to_region, _} when from_region == to_region ->
          {1, %{climber | coordinates: to}}
      end
    end
  end

  defp insert_into_queue({minute, climber}, []) do
    [{minute, MapSet.new([climber])}]
  end

  defp insert_into_queue({minute, climber}, [{head_minute, _head_climbers} = head | tail])
       when head_minute < minute do
    [head | insert_into_queue({minute, climber}, tail)]
  end

  defp insert_into_queue({minute, climber}, [{head_minute, head_climbers} | tail])
       when head_minute == minute do
    [{head_minute, MapSet.put(head_climbers, climber)} | tail]
  end

  defp insert_into_queue({minute, climber}, [{head_minute, _head_climbers} | _tail] = queue)
       when head_minute > minute do
    [{minute, MapSet.new([climber])} | queue]
  end
end
