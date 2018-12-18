defmodule Day12 do
  @moduledoc """
  Documentation for Day12.
  """

  defmodule Pots do
    def new() do
      %{
        start: 0,
        plants: []
      }
    end

    def new(pot_index_pairs) do
      pot_index_pairs
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

    defp to_pots([{_, start_index} | _] = pot_index_pairs) do
      %{
        start: start_index,
        plants: pot_index_pairs |> Enum.map(fn {pot, _index} -> pot end)
      }
    end

    defp trim_trailing_empty_pots(pot_index_pairs) do
      pot_index_pairs
      |> Enum.reverse()
      |> trim_leading_empty_pots
      |> Enum.reverse()
    end

    defp trim_leading_empty_pots([{?., _index} | tail]) do
      trim_leading_empty_pots(tail)
    end

    defp trim_leading_empty_pots(pot_index_pairs) do
      pot_index_pairs
    end

    def llcrr_index_pairs(pots) do
      ([?., ?., ?., ?. | pots.plants] ++ [?., ?., ?., ?.])
      |> Enum.chunk_every(5, 1, :discard)
      |> Enum.with_index(pots.start - 2)
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
    |> Pots.new()
  end

  def spread(pots, notes) do
    pots
    |> Pots.llcrr_index_pairs()
    |> Enum.map(fn {llcrr, index} -> {next_status(notes, llcrr), index} end)
    |> Pots.new()
  end

  defp next_status(notes, llcrr) do
    Map.get(notes, llcrr, ?.)
  end

  def plant_numbers(pots) do
    Pots.plant_numbers(pots)
  end

  def repeat_spread_until_find_the_pattern(pots, notes, target) do
    {old_pots, new_pots, new_index} =
      pots
      |> Stream.iterate(&spread(&1, notes))
      |> Stream.with_index()
      |> Enum.reduce_while(Pots.new(), fn {new_pots, index}, old_pots ->
        if old_pots.plants == new_pots.plants do
          {:halt, {old_pots, new_pots, index}}
        else
          {:cont, new_pots}
        end
      end)

    old_sum = plant_numbers(old_pots) |> Enum.sum()
    new_sum = plant_numbers(new_pots) |> Enum.sum()

    new_sum + (new_sum - old_sum) * (target - new_index)
  end
end
