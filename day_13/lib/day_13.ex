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
    %{tracks: extract_tracks(map), carts: extract_carts(map), crashed_at: []}
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
      %{crashed_at: []} = new_mine -> first_crash_location(new_mine)
      mine -> hd(mine.crashed_at)
    end
  end

  def tick(mine) do
    {moved_carts, crashes} = move_carts_and_crashes(mine.carts, mine.tracks, [], [])

    mine
    |> Map.put(:carts, moved_carts)
    |> Map.update!(:crashed_at, &(crashes ++ &1))
  end

  defp move_carts_and_crashes([], _, moved_carts, crashes) do
    {moved_carts, crashes}
  end

  defp move_carts_and_crashes([cart | carts_tail], tracks, moved_carts, crashes) do
    moved_cart = cart |> move |> turn(tracks)

    cond do
      moved_cart.pos in Enum.map(carts_tail, & &1.pos) ->
        new_carts_tail = carts_tail |> Enum.reject(&(&1.pos == moved_cart.pos))

        move_carts_and_crashes(new_carts_tail, tracks, moved_carts, [moved_cart.pos | crashes])

      moved_cart.pos in Enum.map(moved_carts, & &1.pos) ->
        new_moved_carts = moved_carts |> Enum.reject(&(&1.pos == moved_cart.pos))
        move_carts_and_crashes(carts_tail, tracks, new_moved_carts, [moved_cart.pos | crashes])

      true ->
        move_carts_and_crashes(carts_tail, tracks, [moved_cart | moved_carts], crashes)
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
