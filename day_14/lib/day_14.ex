defmodule Day14 do
  @moduledoc """
  Documentation for Day14.
  """

  alias Day14.Scoreboard

  require Scoreboard

  def ten_recipes_after(index) do
    recipes()
    |> Stream.drop(index)
    |> Enum.take(10)
    |> Enum.join()
  end

  def index_before_recipes(recipes) do
    scoreboard = iterate_until_ended_with(Scoreboard.initial(), recipes)

    Scoreboard.recipes_count(scoreboard.recipes) - String.length(recipes)
  end

  def iterate_until_ended_with(scoreboard, recipes) do
    len = String.length(recipes)

    recipes_count = Scoreboard.recipes_count(scoreboard.recipes)

    ending =
      scoreboard
      |> Scoreboard.slice_recipes((recipes_count - len)..(recipes_count - 1))

    if ending == recipes do
      scoreboard
    else
      iterate_until_ended_with(iterate(scoreboard), recipes)
    end
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

  def iterate(scoreboard) do
    sum = Scoreboard.player1_recipe(scoreboard) + Scoreboard.player2_recipe(scoreboard)

    scoreboard
    |> Scoreboard.append_recipe(Integer.digits(sum))
    |> players_move()
  end

  defp players_move(scoreboard) do
    recipes_length = Scoreboard.recipes_count(scoreboard.recipes)

    new_player1 =
      rem(scoreboard.player1 + Scoreboard.player1_recipe(scoreboard) + 1, recipes_length)

    new_player2 =
      rem(scoreboard.player2 + Scoreboard.player2_recipe(scoreboard) + 1, recipes_length)

    %{scoreboard | player1: new_player1, player2: new_player2}
  end

  def recipes(scoreboard) do
    Scoreboard.recipes(scoreboard)
  end
end
