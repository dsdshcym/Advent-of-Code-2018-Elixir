defmodule ChronalCoordinates do
  def fill_closest(coordinates) do
    for point <- all_points(coordinates), into: Map.new() do
      {point, closest_to(coordinates, point)}
    end
  end

  def largest_infinite_size(coordinates) do
    map = fill_closest(coordinates)

    coordinates
    |> finite_points(map)
    |> Enum.map(fn p -> Enum.count(map, fn {_another_p, closest} -> closest == p end) end)
    |> Enum.max()
  end

  defp finite_points(coordinates, map) do
    {max_x, _} = coordinates |> Enum.max_by(fn {x, _y} -> x end)
    {_, max_y} = coordinates |> Enum.max_by(fn {_x, y} -> y end)

    infinite_points =
      for {x, y} = edge_point <- all_points(coordinates),
          x == 0 or x == max_x or y == 0 or y == max_y,
          into: MapSet.new() do
        map[edge_point]
      end
      |> MapSet.to_list()

    coordinates -- infinite_points
  end

  defp all_points(coordinates) do
    {max_x, _} = coordinates |> Enum.max_by(fn {x, _y} -> x end)
    {_, max_y} = coordinates |> Enum.max_by(fn {_x, y} -> y end)

    for x <- 0..max_x, y <- 0..max_y, do: {x, y}
  end

  defp closest_to(coordinates, point) do
    coordinates
    |> Enum.map(&{&1, manhattan_distance(&1, point)})
    |> Enum.sort_by(fn {_, d} -> d end)
    |> (fn
          [{_closest, d}, {_another_closest, d} | _tail] -> nil
          [{closest, _d} | _tail] -> closest
        end).()
  end

  defp manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end
end

ExUnit.start()

defmodule ChronalCoordinatesTest do
  use ExUnit.Case

  describe "fill_closest/1" do
    test ~S(
      aa
      aA
    ) do
      coordinates = [{1, 1}]

      assert ChronalCoordinates.fill_closest(coordinates) == %{
               {0, 0} => {1, 1},
               {0, 1} => {1, 1},
               {1, 0} => {1, 1},
               {1, 1} => {1, 1}
             }
    end

    test ~S(
      A.B
    ) do
      coordinates = [
        {0, 0},
        {2, 0}
      ]

      assert ChronalCoordinates.fill_closest(coordinates) == %{
               {0, 0} => {0, 0},
               {1, 0} => nil,
               {2, 0} => {2, 0}
             }
    end
  end

  describe "largest_infinite_size/1" do
    test ~S(
      aaaa.bbbb
      aAaa.bbBb
      aaa.d.bbb
      aa.ddd.bb
      ..ddDdd..
      .........
      ccccCcccc
      ccccccccc
    ) do
      coordinates = [
        {1, 1},
        {7, 1},
        {4, 4},
        {4, 6}
      ]

      assert ChronalCoordinates.largest_infinite_size(coordinates) == 9
    end

    test ~S(
      daaaaaaab
      daaaAaaab
      dd.aaa.bb
      dd.eee.bb
      Dd.eEe.bB
      dd.eee.bb
      dccccccbb
      dcccCcccb
    ) do
      coordinates = [
        {4, 1},
        {8, 4},
        {4, 4},
        {0, 4},
        {4, 7}
      ]

      assert ChronalCoordinates.largest_infinite_size(coordinates) == 9
    end

    test "example" do
      coordinates = [
        {1, 1},
        {1, 6},
        {8, 3},
        {3, 4},
        {5, 5},
        {8, 9}
      ]

      assert ChronalCoordinates.largest_infinite_size(coordinates) == 17
    end

    test "puzzle input" do
      assert "./fixtures/day_6.txt"
             |> File.read!()
             |> String.split("\n", trim: true)
             |> Enum.map(fn line ->
               line |> String.split(", ") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
             end)
             |> ChronalCoordinates.largest_infinite_size() == 3006
    end
  end
end
