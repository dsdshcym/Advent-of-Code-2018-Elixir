defmodule Day25 do
  def part_1(input) do
    input
    |> parse()
    |> constellations_count()
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  defp constellations_count(points) do
    constellations_count(points, %{})
  end

  defp constellations_count([], constellations) do
    Enum.count(constellations)
  end

  defp constellations_count([point | rest], constellations) do
    updated_constellations =
      constellations
      |> Enum.filter(fn {_key, constellation_points} ->
        Enum.any?(constellation_points, fn constellation_point ->
          manhattan_distance(constellation_point, point) <= 3
        end)
      end)
      |> case do
        [] ->
          Map.put(constellations, point, [point])

        connected_constellations ->
          merged_constellation =
            connected_constellations
            |> Enum.reduce([], fn {_, constellation}, acc -> acc ++ constellation end)

          connected_constellations
          |> Enum.reduce(constellations, fn {key, _constellation}, acc ->
            Map.delete(acc, key)
          end)
          |> Map.put(point, [point | merged_constellation])
      end

    constellations_count(rest, updated_constellations)
  end

  defp manhattan_distance([a1, b1, c1, d1], [a2, b2, c2, d2]) do
    abs(a1 - a2) + abs(b1 - b2) + abs(c1 - c2) + abs(d1 - d2)
  end
end
