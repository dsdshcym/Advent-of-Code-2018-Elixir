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

    test "puzzle input" do
      assert Day14.index_before_recipes("#{@input}") == 20_211_326
    end
  end
end
