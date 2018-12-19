defmodule Day14 do
  @moduledoc """
  Documentation for Day14.
  """

  def ten_recipes_after(index) do
    scoreboard = iterate_until(%{recipes: %{0 => 3, 1 => 7}, player1: 0, player2: 1}, index + 10)

    index..(index + 10 - 1)
    |> Enum.map(&scoreboard.recipes[&1])
  end

  def index_before_recipes(recipes) do
    scoreboard =
      iterate_until_ended_with(%{recipes: %{0 => 3, 1 => 7}, player1: 0, player2: 1}, recipes)

    map_size(scoreboard.recipes) - String.length(recipes)
  end

  def iterate_until_ended_with(scoreboard, recipes) do
    len = String.length(recipes)

    recipes_count = map_size(scoreboard.recipes)

    ending =
      (recipes_count - len)..(recipes_count - 1)
      |> Enum.map(&scoreboard.recipes[&1])
      |> Enum.join()

    if ending == recipes do
      scoreboard
    else
      iterate_until_ended_with(iterate(scoreboard), recipes)
    end
  end

  def iterate_until(%{recipes: recipes} = scoreboard, target) when map_size(recipes) >= target do
    scoreboard
  end

  def iterate_until(scoreboard, target) do
    scoreboard
    |> iterate()
    |> iterate_until(target)
  end

  def iterate(scoreboard) do
    sum = scoreboard.recipes[scoreboard.player1] + scoreboard.recipes[scoreboard.player2]

    scoreboard
    |> append_recipe(digits(sum))
    |> players_move()
  end

  defp append_recipe(scoreboard, digits) when is_list(digits) do
    digits
    |> Enum.reduce(scoreboard, fn digit, scoreboard -> append_recipe(scoreboard, digit) end)
  end

  defp append_recipe(scoreboard, digit) do
    pos = map_size(scoreboard.recipes)

    put_in(scoreboard, [:recipes, pos], digit)
  end

  defp players_move(scoreboard) do
    recipes_length = map_size(scoreboard.recipes)

    new_player1 =
      rem(scoreboard.player1 + scoreboard.recipes[scoreboard.player1] + 1, recipes_length)

    new_player2 =
      rem(scoreboard.player2 + scoreboard.recipes[scoreboard.player2] + 1, recipes_length)

    %{scoreboard | player1: new_player1, player2: new_player2}
  end

  defp digits(num) do
    num
    |> Integer.to_string()
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
  end

  def recipes(scoreboard) do
    scoreboard.recipes |> Map.values() |> Enum.join()
  end
end
