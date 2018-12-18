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

  def tick(mine) do
    new_carts = move_carts(mine.carts, mine.tracks)

    %{mine | carts: new_carts}
  end

  defp move_carts(_, _, moved_carts \\ [])

  defp move_carts([], _, moved_carts) do
    moved_carts
  end

  defp move_carts([cart | carts_tail], tracks, moved_carts) do
    moved_cart = cart |> move |> turn(tracks)

    move_carts(carts_tail, tracks, [moved_cart | moved_carts])
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
