defmodule Day10 do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    Regex.scan(~r/-?[0-9]+/, line)
    |> Enum.map(fn
      [num_str | _] -> String.to_integer(num_str)
    end)
    |> List.to_tuple()
  end

  def tick(world) do
    world
    |> Enum.map(&move/1)
  end

  defp move({x, y, vx, vy}) do
    {x + vx, y + vy, vx, vy}
  end

  def to_s(world) do
    points = world |> Enum.map(fn {x, y, _vx, _vy} -> {x, y} end)

    {x_range, y_range} = points |> axis_range()

    Enum.map(y_range, fn y ->
      Enum.map(x_range, fn x ->
        if {x, y} in points, do: "#", else: "."
      end)
      |> Enum.join()
    end)
    |> Enum.join("\n")
  end

  defp axis_range(points) do
    {{min_x, _}, {max_x, _}} = Enum.min_max_by(points, fn {x, _y} -> x end)
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(points, fn {_x, y} -> y end)

    {(min_x - 1)..(max_x + 1), (min_y - 1)..(max_y + 1)}
  end

  def wait_until_minimal_y_diff(world) do
    world
    |> Stream.iterate(&tick/1)
    |> Enum.reduce_while({nil, nil}, fn new_world, {last_world, last_y_diff} ->
      new_y_diff = y_diff(new_world)

      if last_y_diff == nil || new_y_diff < last_y_diff do
        {:cont, {new_world, new_y_diff}}
      else
        {:halt, last_world}
      end
    end)
  end

  defp y_diff(world) do
    points = world |> Enum.map(fn {x, y, _vx, _vy} -> {x, y} end)
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(points, fn {_x, y} -> y end)

    max_y - min_y
  end

  def seconds_until_minimal_y_diff(world) do
    world
    |> Stream.iterate(&tick/1)
    |> Enum.reduce_while({0, nil}, fn new_world, {seconds, last_y_diff} ->
      new_y_diff = y_diff(new_world)

      if last_y_diff == nil || new_y_diff < last_y_diff do
        {:cont, {seconds + 1, new_y_diff}}
      else
        {:halt, seconds - 1}
      end
    end)
  end
end
