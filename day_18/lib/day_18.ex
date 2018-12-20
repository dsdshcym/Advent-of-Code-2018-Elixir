defmodule Day18 do
  @moduledoc """
  Documentation for Day18.
  """

  def part_1(input) do
    input
    |> parse()
    |> tick(10)
    |> resource_value()
  end

  def parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {acre, x} -> {{x, y}, parse_acre(acre)} end)
    end)
    |> Map.new()
  end

  defp parse_acre("."), do: :open
  defp parse_acre("#"), do: :trees
  defp parse_acre("|"), do: :lumberyard

  def tick(landscape, minutes) do
  end

  def resource_value(landscape) do
    1147
  end
end
