defmodule Day14.Scoreboard do
  def initial() do
    recipes = :ets.new(:recipes, [:private, read_concurrency: true, write_concurrency: true])

    %{recipes: recipes, player1: 0, player2: 1}
    |> append_recipe([3, 7])
  end

  def recipes_count(recipes) do
    :ets.info(recipes, :size)
  end

  def player1_recipe(scoreboard) do
    recipe_at(scoreboard, scoreboard.player1)
  end

  def player2_recipe(scoreboard) do
    recipe_at(scoreboard, scoreboard.player2)
  end

  defp recipe_at(scoreboard, pos) do
    [{^pos, recipe}] = :ets.lookup(scoreboard.recipes, pos)

    recipe
  end

  def append_recipe(scoreboard, digits)
      when is_list(digits) do
    digits
    |> Enum.reduce(scoreboard, fn digit, scoreboard -> append_recipe(scoreboard, digit) end)
  end

  def append_recipe(scoreboard, digit) do
    pos = recipes_count(scoreboard.recipes)

    :ets.insert(scoreboard.recipes, {pos, digit})

    scoreboard
  end
end
