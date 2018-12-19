defmodule Day14Test do
  use ExUnit.Case
  doctest Day14

  @input 554_401

  describe "part 1" do
    test "examples" do
      assert Day14.ten_recipes_after(9) == "5158916779"
      assert Day14.ten_recipes_after(5) == "0124515891"
      assert Day14.ten_recipes_after(18) == "9251071085"
      assert Day14.ten_recipes_after(2018) == "5941429882"
    end

    test "puzzle input" do
      assert Day14.ten_recipes_after(@input) == "3610281143"
    end
  end

  describe "part 2" do
    test "examples" do
      assert Day14.index_before_recipes("51589") == 9
      assert Day14.index_before_recipes("01245") == 5
      assert Day14.index_before_recipes("92510") == 18
      assert Day14.index_before_recipes("59414") == 2018
    end

    @tag skip: true
    test "puzzle input" do
      assert Day14.index_before_recipes("#{@input}") == 1
    end
  end

  describe "iterate/1" do
    test "appends recipes with the sum of the current recipes' scores (when sum is single digit)" do
      scoreboard =
        Day14.iterate(new_scoreboard(recipes: %{0 => 1, 1 => 2}, player1: 0, player2: 1))

      assert Day14.recipes(scoreboard) == "123"
    end

    test "appends recipes with the digits of the sum of the current recipes' scores" do
      scoreboard =
        Day14.iterate(new_scoreboard(recipes: %{0 => 9, 1 => 9}, player1: 0, player2: 1))

      assert Day14.recipes(scoreboard) == "9918"
    end

    test "steps forward players by 1 plus the score of their current recipe after recipe appendment" do
      scoreboard =
        Day14.iterate(
          new_scoreboard(recipes: %{0 => 3, 1 => 7, 2 => 1, 3 => 0}, player1: 0, player2: 1)
        )

      assert scoreboard.player1 == 4
      assert scoreboard.player2 == 3
    end
  end

  defp new_scoreboard(recipes: recipes, player1: player1, player2: player2) do
    %{recipes: recipes, player1: player1, player2: player2}
  end
end
