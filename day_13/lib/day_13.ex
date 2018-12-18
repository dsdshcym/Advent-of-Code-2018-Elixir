defmodule Day13 do
  @moduledoc """
  Documentation for Day13.
  """

  def parse(input) do
    input
    |> generate_map()
    |> generate_mine()
  end

  defp generate_map(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {point, x} ->
        {{x, y}, point}
      end)
    end)
    |> Enum.reject(fn {_pos, point} -> point == " " end)
  end

  defp generate_mine(map) do
    %{tracks: extract_tracks(map), carts: extract_carts(map)}
  end

  defp extract_tracks(map) do
    map
    |> Enum.map(fn
      {pos, "<"} -> {pos, "-"}
      {pos, ">"} -> {pos, "-"}
      {pos, "v"} -> {pos, "|"}
      {pos, "^"} -> {pos, "|"}
      tracks -> tracks
    end)
    |> Map.new()
  end

  defp extract_carts(map) do
    map
    |> Enum.filter(fn {_pos, point} -> point in ["<", ">", "v", "^"] end)
    |> Enum.map(&new_cart/1)
  end

  defp new_cart({pos, cart}) do
    %{
      pos: pos,
      direction: cart,
      turn_option: :left
    }
  end

  def first_crash_location(mine) do
    case tick(mine) do
      %{crashed_at: crashed_at} -> crashed_at
      new_mine -> first_crash_location(new_mine)
    end
  end

  def tick(mine) do
    case move_carts_and_detect_crash(mine.carts, mine.tracks) do
      {:ok, moved_carts} ->
        %{mine | carts: moved_carts}

      {:crash, crashed_at} ->
        Map.put(mine, :crashed_at, crashed_at)
    end
  end

  defp move_carts_and_detect_crash(_, _, moved_carts \\ [])

  defp move_carts_and_detect_crash([], _, moved_carts) do
    {:ok, moved_carts}
  end

  defp move_carts_and_detect_crash([cart | carts_tail], tracks, moved_carts) do
    moved_cart = cart |> move |> turn(tracks)

    other_carts = carts_tail ++ moved_carts

    if moved_cart.pos in Enum.map(other_carts, & &1.pos) do
      {:crash, moved_cart.pos}
    else
      move_carts_and_detect_crash(carts_tail, tracks, [moved_cart | moved_carts])
    end
  end

  defp move(cart) do
    cart
    |> Map.update!(:pos, fn pos ->
      update_pos(pos, to_vector(cart.direction))
    end)
  end

  defp turn(cart, tracks) do
    cart
    |> Map.update!(:direction, fn _ ->
      update_direction(cart.direction, tracks[cart.pos], cart.turn_option)
    end)
    |> Map.update!(:turn_option, fn turn_option ->
      update_turn_option(turn_option, tracks[cart.pos])
    end)
  end

  defp update_pos({x, y}, {vx, vy}), do: {x + vx, y + vy}

  defp to_vector(">"), do: {1, 0}
  defp to_vector("<"), do: {-1, 0}
  defp to_vector("v"), do: {0, 1}
  defp to_vector("^"), do: {0, -1}

  defp update_direction(direction, "-", _turn_option), do: direction
  defp update_direction(direction, "|", _turn_option), do: direction

  defp update_direction(">", "\\", _turn_option), do: "v"
  defp update_direction("^", "\\", _turn_option), do: "<"
  defp update_direction("v", "\\", _turn_option), do: ">"
  defp update_direction("<", "\\", _turn_option), do: "^"
  defp update_direction(">", "/", _turn_option), do: "^"
  defp update_direction("^", "/", _turn_option), do: ">"
  defp update_direction("v", "/", _turn_option), do: "<"
  defp update_direction("<", "/", _turn_option), do: "v"

  defp update_direction(direction, "+", :straight), do: direction

  defp update_direction("<", "+", :left), do: "v"
  defp update_direction("<", "+", :right), do: "^"

  defp update_direction("v", "+", :left), do: ">"
  defp update_direction("v", "+", :right), do: "<"

  defp update_direction(">", "+", :left), do: "^"
  defp update_direction(">", "+", :right), do: "v"

  defp update_direction("^", "+", :left), do: "<"
  defp update_direction("^", "+", :right), do: ">"

  defp update_turn_option(:left, "+"), do: :straight
  defp update_turn_option(:straight, "+"), do: :right
  defp update_turn_option(:right, "+"), do: :left
  defp update_turn_option(turn_option, _), do: turn_option
end
