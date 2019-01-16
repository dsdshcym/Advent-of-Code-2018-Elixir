defmodule Day17 do
  def part_1(input) do
    input
    |> build_ground()
    |> fill_water()
    |> tiles_count_by_element_type([:flow, :still])
  end

  def part_2(input) do
    input
    |> build_ground()
    |> fill_water()
    |> tiles_count_by_element_type([:still])
  end

  defp build_ground(input) do
    state =
      input
      |> String.split("\n", trim: true)
      |> Enum.flat_map(&to_clay_vain/1)
      |> Enum.map(&{&1, :clay})
      |> Map.new()

    {top, bottom} =
      state
      |> Map.keys()
      |> Enum.map(fn {_x, y} -> y end)
      |> Enum.min_max()

    %{
      state: state,
      top: top,
      bottom: bottom
    }
  end

  defp to_clay_vain(line) do
    line
    |> String.split(", ")
    |> case do
      ["x=" <> x, "y=" <> y_range] ->
        x = String.to_integer(x)
        y_range = parse_range(y_range)

        for y <- y_range, do: {x, y}

      ["y=" <> y, "x=" <> x_range] ->
        y = String.to_integer(y)
        x_range = parse_range(x_range)

        for x <- x_range, do: {x, y}
    end
  end

  defp parse_range(range) do
    [from, to] =
      range
      |> String.split("..")
      |> Enum.map(&String.to_integer/1)

    from..to
  end

  defp fill_water(ground) do
    {_, ground} = fill_water(ground, {500, 1})

    ground
  end

  defp fill_water(ground, pos) do
    case element_at(ground, pos) do
      :sand -> place_water_on_sand(ground, pos)
      other -> {other, ground}
    end
  end

  defp place_water_on_sand(ground, pos) do
    if beneath_all_clays(pos, ground) do
      {:flow, ground}
    else
      ground = store_water_state(ground, pos, :still)

      case fill_water(ground, down(pos)) do
        {:flow, ground} ->
          {:flow, store_water_state(ground, pos, :flow)}

        {element, ground} when element in [:still, :clay] ->
          {left_element, ground} = fill_water(ground, left(pos))
          {right_element, ground} = fill_water(ground, right(pos))

          if left_element == :flow or right_element == :flow do
            ground =
              ground
              |> store_water_state(pos, :flow)
              |> mark_flow(pos, &left/1)
              |> mark_flow(pos, &right/1)

            {:flow, ground}
          else
            {:still, ground}
          end
      end
    end
  end

  defp mark_flow(ground, pos, move_fun) do
    move_fun.(pos)
    |> Stream.iterate(move_fun)
    |> Stream.take_while(&(element_at(ground, &1) == :still))
    |> Enum.reduce(ground, &store_water_state(&2, &1, :flow))
  end

  defp beneath_all_clays({_, y}, %{bottom: bottom}) do
    y > bottom
  end

  defp store_water_state(ground, pos, state) do
    put_in(ground.state[pos], state)
  end

  defp element_at(ground, pos) do
    Map.get(ground.state, pos, :sand)
  end

  defp down({x, y}) do
    {x, y + 1}
  end

  defp left({x, y}) do
    {x - 1, y}
  end

  defp right({x, y}) do
    {x + 1, y}
  end

  defp tiles_count_by_element_type(ground, types) do
    ground.state
    |> Enum.filter(fn {_pos, element} -> element in types end)
    |> Enum.filter(fn {{_, y}, _} -> y >= ground.top and y <= ground.bottom end)
    |> Enum.count()
  end
end
