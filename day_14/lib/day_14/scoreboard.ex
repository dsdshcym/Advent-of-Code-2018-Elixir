defmodule Day14.Scoreboard do
  defguard enough_recipes(recipes, target) when map_size(recipes) >= target

  def initial() do
    %{recipes: %{0 => 3, 1 => 7}, player1: 0, player2: 1}
  end

  def slice_recipes(scoreboard, range) do
    range
    |> Enum.map(&scoreboard.recipes[&1])
    |> Enum.join()
  end

  def recipes_count(recipes) do
    map_size(recipes)
  end

  def player1_recipe(scoreboard) do
    scoreboard.recipes[scoreboard.player1]
  end

  def player2_recipe(scoreboard) do
    scoreboard.recipes[scoreboard.player2]
  end

  def append_recipe(scoreboard, digits)
      when is_list(digits) do
    digits
    |> Enum.reduce(scoreboard, fn digit, scoreboard -> append_recipe(scoreboard, digit) end)
  end

  def append_recipe(scoreboard, digit) do
    pos = recipes_count(scoreboard.recipes)

    put_in(scoreboard, [:recipes, pos], digit)
  end

  def recipes(scoreboard) do
    scoreboard.recipes |> Map.values() |> Enum.join()
  end
end
