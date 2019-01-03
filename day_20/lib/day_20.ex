defmodule Day20 do
  @moduledoc """
  Documentation for Day20.
  """

  def part_1(input) do
    input
    |> parse_input()
    |> build_map()
    |> furthest_distance({0, 0})
  end

  def parse_input(string) do
    path_size = byte_size(string) - 2

    <<"^", path_string::binary-size(path_size), "$">> = string

    parse_path(path_string, [])
  end

  defp parse_path(input, acc, branches \\ [], stack \\ [])

  defp parse_path("N" <> rest, acc, branches, stack) do
    parse_path(rest, [:north | acc], branches, stack)
  end

  defp parse_path("W" <> rest, acc, branches, stack) do
    parse_path(rest, [:west | acc], branches, stack)
  end

  defp parse_path("S" <> rest, acc, branches, stack) do
    parse_path(rest, [:south | acc], branches, stack)
  end

  defp parse_path("E" <> rest, acc, branches, stack) do
    parse_path(rest, [:east | acc], branches, stack)
  end

  defp parse_path("(" <> rest, acc, branches, stack) do
    parse_path(rest, [], [], [{acc, branches} | stack])
  end

  defp parse_path(")" <> rest, current_branch, branches, [{acc, prev_branches} | stack]) do
    branches = [Enum.reverse(current_branch) | branches] |> Enum.reverse()

    parse_path(rest, [branches | acc], prev_branches, stack)
  end

  defp parse_path("|" <> rest, current_branch, branches, stack) do
    parse_path(rest, [], [Enum.reverse(current_branch) | branches], stack)
  end

  defp parse_path("", acc, [], []) do
    Enum.reverse(acc)
  end

  def build_map(routes) do
    {_, map} = build_map(routes, MapSet.new([{0, 0}]), %{})

    map
  end

  defp build_map([], current_positions, map), do: {current_positions, map}

  defp build_map([direction | rest], current_positions, map) when is_atom(direction) do
    {new_positions, new_map} =
      current_positions
      |> Enum.map_reduce(
        map,
        fn pos, map ->
          next_pos = move(pos, direction)
          new_map = add_edge(map, pos, next_pos)

          {next_pos, new_map}
        end
      )

    build_map(rest, MapSet.new(new_positions), new_map)
  end

  defp build_map([branches | rest], current_positions, map) when is_list(branches) do
    {new_positions, new_map} =
      branches
      |> Enum.map(&build_map(&1, current_positions, map))
      |> Enum.reduce(fn
        {positions1, map1}, {positions2, map2} ->
          {merge_positions(positions1, positions2), merge_maps(map1, map2)}
      end)

    build_map(rest, new_positions, new_map)
  end

  defp merge_positions(positions1, positions2) do
    MapSet.union(positions1, positions2)
  end

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _node, neighbors1, neighbors2 ->
      MapSet.union(neighbors1, neighbors2)
    end)
  end

  defp move({x, y}, :north), do: {x, y + 1}
  defp move({x, y}, :south), do: {x, y - 1}
  defp move({x, y}, :east), do: {x + 1, y}
  defp move({x, y}, :west), do: {x - 1, y}

  defp add_edge(map, node1, node2) do
    map
    |> Map.update(node1, MapSet.new([node2]), &MapSet.put(&1, node2))
    |> Map.update(node2, MapSet.new([node1]), &MapSet.put(&1, node1))
  end

  def furthest_distance(map, start) do
    furthest_distance(map, MapSet.new([start]), MapSet.new(), 0)
  end

  defp furthest_distance(map, current_nodes, visited_nodes, current_distance) do
    if MapSet.size(current_nodes) == 0 do
      current_distance - 1
    else
      visited_nodes = MapSet.union(current_nodes, visited_nodes)

      current_neighbors =
        current_nodes
        |> Enum.map(&Map.fetch!(map, &1))
        |> Enum.reduce(&MapSet.union/2)

      next_nodes = MapSet.difference(current_neighbors, visited_nodes)

      furthest_distance(map, next_nodes, visited_nodes, current_distance + 1)
    end
  end

  def distances_to_other_nodes(map, start) do
    distances_to_other_nodes(map, MapSet.new([start]), %{start => 0}, 0)
  end

  def distances_to_other_nodes(map, current_nodes, distances, current_distance) do
    if MapSet.size(current_nodes) == 0 do
      distances
    else
      new_distances =
        current_nodes
        |> Enum.map(&{&1, current_distance})
        |> Map.new()
        |> Map.merge(distances)

      visited_nodes = new_distances |> Map.keys() |> MapSet.new()

      current_neighbors =
        current_nodes
        |> Enum.map(&Map.fetch!(map, &1))
        |> Enum.reduce(&MapSet.union/2)

      next_nodes = MapSet.difference(current_neighbors, visited_nodes)

      distances_to_other_nodes(map, next_nodes, new_distances, current_distance + 1)
    end
  end
end
