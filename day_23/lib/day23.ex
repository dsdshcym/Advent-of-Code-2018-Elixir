defmodule Day23 do
  def part_1(input) do
    input
    |> parse()
    |> nanobots_count_in_range_of_the_strongest()
  end

  def part_2(input) do
    input
    |> parse()
    |> manhattan_distance_to_the_closest_position_in_range_of_the_largest_number_of_nanobots()
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_nanobot/1)
  end

  @coordinate "-?[0-9]+"
  @radius "[0-9]+"

  @regexp ~r/^pos=<(?<x>#{@coordinate}),(?<y>#{@coordinate}),(?<z>#{@coordinate})>, r=(?<r>#{
            @radius
          })$/
  defp parse_nanobot(line) do
    [^line | captures] = Regex.run(@regexp, line)
    [x, y, z, r] = Enum.map(captures, &String.to_integer/1)

    %{coordinates: {x, y, z}, r: r}
  end

  defp nanobots_count_in_range_of_the_strongest(nanobots) do
    nanobots
    |> strongest()
    |> in_range_of(nanobots)
    |> Enum.count()
  end

  defp strongest(nanobots) do
    nanobots
    |> Enum.max_by(& &1.r)
  end

  defp manhattan_distance_to_the_closest_position_in_range_of_the_largest_number_of_nanobots(
         nanobots
       ) do
    nanobots
    |> positions_in_range_of_the_largest_number_of_nanobots()
    |> Enum.map(&manhattan_distance({0, 0, 0}, &1))
    |> Enum.min()
  end

  defp positions_in_range_of_the_largest_number_of_nanobots(nanobots) do
    [surrounding_cube(nanobots)]
    |> Stream.unfold(fn cubes ->
      with {best_cube, cubes} <- pop_best_cube(cubes) do
        case split_cube(best_cube, nanobots) do
          {:ok, splitted_cubes} -> {best_cube, splitted_cubes ++ cubes}
          :cannot_be_splitted -> {best_cube, cubes}
        end
      end
    end)
    |> Stream.filter(&contains_only_one_position?/1)
    |> Stream.chunk_by(& &1.bots_count)
    |> Enum.at(0)
    |> Enum.map(&to_position/1)
  end

  defp surrounding_cube(nanobots) do
    coordinates =
      nanobots
      |> Enum.map(& &1.coordinates)

    {x_first, x_last} =
      coordinates
      |> Enum.map(fn {x, _, _} -> x end)
      |> Enum.min_max()

    {y_first, y_last} =
      coordinates
      |> Enum.map(fn {_, y, _} -> y end)
      |> Enum.min_max()

    {z_first, z_last} =
      coordinates
      |> Enum.map(fn {_, _, z} -> z end)
      |> Enum.min_max()

    %{x_range: x_first..x_last, y_range: y_first..y_last, z_range: z_first..z_last}
    |> insert_intersected_bots_count(nanobots)
  end

  defp pop_best_cube(cubes) do
    cubes
    |> Enum.reduce(nil, fn
      cube, nil ->
        {cube, []}

      cube, {best, cubes} ->
        if cube.bots_count > best.bots_count do
          {cube, [best | cubes]}
        else
          {best, [cube | cubes]}
        end
    end)
  end

  defp split_cube(cube, nanobots) do
    if contains_only_one_position?(cube) do
      :cannot_be_splitted
    else
      splitted_cubes =
        for splitted_x_range <- split_range(cube.x_range),
            splitted_y_range <- split_range(cube.y_range),
            splitted_z_range <- split_range(cube.z_range) do
          %{
            x_range: splitted_x_range,
            y_range: splitted_y_range,
            z_range: splitted_z_range
          }
          |> insert_intersected_bots_count(nanobots)
        end

      {:ok, splitted_cubes}
    end
  end

  defp split_range(first..last = range) when first == last do
    [range]
  end

  defp split_range(first..last) do
    middle = div(first + last, 2)
    [first..middle, (middle + 1)..last]
  end

  defp contains_only_one_position?(cube) do
    Enum.count(cube.x_range) == 1 and
      Enum.count(cube.y_range) == 1 and
      Enum.count(cube.z_range) == 1
  end

  defp to_position(cube) do
    x..x = cube.x_range
    y..y = cube.y_range
    z..z = cube.z_range
    {x, y, z}
  end

  defp insert_intersected_bots_count(cube, nanobots) do
    cube
    |> Map.put(:bots_count, Enum.count(nanobots, &intersect?(cube, &1)))
  end

  defp intersect?(cube, nanobot) do
    in_range?(nanobot, closest_point(cube, nanobot))
  end

  defp closest_point(cube, %{coordinates: {x, y, z}} = _nanobot) do
    {
      closest_coordinate(cube.x_range, x),
      closest_coordinate(cube.y_range, y),
      closest_coordinate(cube.z_range, z)
    }
  end

  defp closest_coordinate(first.._last, target) when target < first, do: first
  defp closest_coordinate(_first..last, target) when target > last, do: last
  defp closest_coordinate(_first.._last, target), do: target

  defp in_range_of(nanobot, nanobots) do
    nanobots
    |> Enum.filter(&in_range?(nanobot, &1))
  end

  defp in_range?(bot, coordinates) when is_tuple(coordinates) do
    manhattan_distance(bot.coordinates, coordinates) <= bot.r
  end

  defp in_range?(bot1, bot2) do
    manhattan_distance(bot1, bot2) <= bot1.r
  end

  defp manhattan_distance({x1, y1, z1}, {x2, y2, z2}) do
    abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)
  end

  defp manhattan_distance(bot1, bot2) do
    manhattan_distance(bot1.coordinates, bot2.coordinates)
  end
end
