defmodule Day14.StringScoreboard do
  def initial() do
    %{recipes: "37", player1: 0, player2: 1}
  end

  def recipes_count(recipes) do
    byte_size(recipes)
  end

  def player1_recipe(scoreboard) do
    :binary.at(scoreboard.recipes, scoreboard.player1) - ?0
  end

  def player2_recipe(scoreboard) do
    :binary.at(scoreboard.recipes, scoreboard.player2) - ?0
  end

  def append_recipe(scoreboard, digits)
      when is_list(digits) do
    Map.update!(scoreboard, :recipes, &(&1 <> Enum.join(digits)))
  end
end
