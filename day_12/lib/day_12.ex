defmodule Day12 do
  @moduledoc """
  Documentation for Day12.
  """

  defmodule Pots do
    def new(index_pot_pairs) do
      index_pot_pairs
      |> trim_leading_empty_pots()
      |> trim_trailing_empty_pots()
      |> to_pots()
    end

    defp to_pots([]) do
      %{
        start: 0,
        plants: []
      }
    end

    defp to_pots([{start_index, _} | _] = index_pot_pairs) do
      %{
        start: start_index,
        plants: index_pot_pairs |> Enum.map(fn {_index, pot} -> pot end)
      }
    end

    defp trim_trailing_empty_pots(index_pot_pairs) do
      index_pot_pairs
      |> Enum.reverse()
      |> trim_leading_empty_pots
      |> Enum.reverse()
    end

    defp trim_leading_empty_pots([{_index, ?.} | tail]) do
      trim_leading_empty_pots(tail)
    end

    defp trim_leading_empty_pots(index_pot_pairs) do
      index_pot_pairs
    end

    def index_llcrr_pairs(pots) do
      ([?., ?., ?., ?. | pots.plants] ++ [?., ?., ?., ?.])
      |> Enum.chunk_every(5, 1, :discard)
      |> Enum.with_index(pots.start - 2)
      |> Enum.map(fn {llcrr, index} -> {index, llcrr} end)
    end

    def plant_numbers(pots) do
      pots.plants
      |> Enum.with_index(pots.start)
      |> Enum.filter(fn {plant, _index} -> plant == ?# end)
      |> Enum.map(fn {_plant, index} -> index end)
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
