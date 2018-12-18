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
end
