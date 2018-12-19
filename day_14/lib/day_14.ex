defmodule Day14 do
  @moduledoc """
  Documentation for Day14.
  """

  alias Day14.StringScoreboard, as: Scoreboard

  require Scoreboard

  def ten_recipes_after(index) do
    recipes()
    |> Stream.drop(index)
    |> Enum.take(10)
    |> Enum.join()
  end

  def index_before_recipes(recipes) when is_binary(recipes) do
    recipes =
      recipes
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)

    index_before_recipes(recipes)
  end

  def index_before_recipes(recipes) do
    recipes()
    |> Enum.reduce_while({recipes, recipes, 0}, fn
      _, {[], _, index} ->
        {:halt, index - length(recipes)}

      recipe, {[recipe | rest], orig_recipes, index} ->
        {:cont, {rest, orig_recipes, index + 1}}

      recipe, {_, [recipe | rest] = orig_recipes, index} ->
        {:cont, {rest, orig_recipes, index + 1}}

      _, {_, orig_recipes, index} ->
        {:cont, {orig_recipes, orig_recipes, index + 1}}
    end)
  end

  defp recipes() do
    Stream.concat(
      [3, 7],
      Stream.resource(
        &Scoreboard.initial/0,
        &iterate_with_new_recipes/1,
        fn _ -> :ok end
      )
    )
  end

  def iterate_with_new_recipes(scoreboard) do
    digits =
      Integer.digits(
        Scoreboard.player1_recipe(scoreboard) + Scoreboard.player2_recipe(scoreboard)
      )

    {
      digits,
      scoreboard |> Scoreboard.append_recipe(digits) |> players_move()
    }
  end

  defp players_move(scoreboard) do
    recipes_length = Scoreboard.recipes_count(scoreboard.recipes)

    new_player1 =
      rem(scoreboard.player1 + Scoreboard.player1_recipe(scoreboard) + 1, recipes_length)

    new_player2 =
      rem(scoreboard.player2 + Scoreboard.player2_recipe(scoreboard) + 1, recipes_length)

    %{scoreboard | player1: new_player1, player2: new_player2}
  end
end
