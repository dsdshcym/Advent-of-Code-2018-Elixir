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
    {min, max} = pots |> plant_numbers() |> Enum.min_max()

    (min - 2)..(max + 2)
    |> Enum.map(fn index -> {index, next_status(pots, notes, index)} end)
    |> Map.new()
  end

  defp next_status(pots, notes, index) do
    llcrr = (index - 2)..(index + 2) |> Enum.map(&Map.get(pots, &1, ?.))

    Map.get(notes, llcrr, ?.)
  end

  def plant_numbers(pots) do
    pots
    |> Enum.filter(fn {_index, plant} -> plant == ?# end)
    |> Enum.map(fn {index, _plant} -> index end)
  end
end
