defmodule Day12 do
  @moduledoc """
  Documentation for Day12.
  """

  def pots(input) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {pot, index} -> {index, pot} end)
    |> Map.new()
  end

  def spread(pots, notes) do
    left = extend_left_and_right(pots, notes)

    pots
    |> Map.keys()
    |> Enum.map(fn index -> {index, next_status(pots, notes, index)} end)
    |> Map.new()
    |> Map.merge(left)
  end

  defp next_status(pots, notes, index) do
    llcrr = (index - 2)..(index + 2) |> Enum.map(&Map.get(pots, &1, ?.))

    Map.get(notes, llcrr, ?.)
  end

  defp extend_left_and_right(pots, notes) do
    {min, max} = pots |> Map.keys() |> Enum.min_max()

    [min - 2, min - 1, max + 1, max + 2]
    |> Enum.reduce(%{}, fn index, new_pots ->
      case next_status(pots, notes, index) do
        nil -> new_pots
        ?. -> new_pots
        ?# -> Map.put(new_pots, index, ?#)
      end
    end)
  end

  def plant_numbers(pots) do
    pots
    |> Enum.filter(fn {_index, plant} -> plant == ?# end)
    |> Enum.map(fn {index, _plant} -> index end)
  end
end
