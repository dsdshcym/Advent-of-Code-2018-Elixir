defmodule Day12 do
  @moduledoc """
  Documentation for Day12.
  """

  defmodule Pots do
    def new(index_pot_pairs) do
      index_pot_pairs
      |> Map.new()
    end

    def index_llcrr_pairs(pots) do
      {min, max} = pots |> plant_numbers() |> Enum.min_max()

      (min - 2)..(max + 2)
      |> Enum.map(fn index -> {index, llcrr(pots, index)} end)
    end

    def plant_numbers(pots) do
      pots
      |> Enum.filter(fn {_index, plant} -> plant == ?# end)
      |> Enum.map(fn {index, _plant} -> index end)
    end

    defp llcrr(pots, index) do
      (index - 2)..(index + 2) |> Enum.map(&Map.get(pots, &1, ?.))
    end
  end

  def pots(input) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {pot, index} -> {index, pot} end)
    |> Pots.new()
  end

  def spread(pots, notes) do
    pots
    |> Pots.index_llcrr_pairs()
    |> Enum.map(fn {index, llcrr} -> {index, next_status(notes, llcrr)} end)
    |> Pots.new()
  end

  defp next_status(notes, llcrr) do
    Map.get(notes, llcrr, ?.)
  end

  def plant_numbers(pots) do
    Pots.plant_numbers(pots)
  end
end
