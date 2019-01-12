defmodule Day22Test do
  use ExUnit.Case
  doctest Day22

  describe "part 1" do
    test "example" do
      assert Day22.part_1(510, {10, 10}) == 114
    end

    test "puzzle input" do
      assert Day22.part_1(4848, {15, 700}) == 11359
    end
  end

  describe "part 2" do
    test "example" do
      assert Day22.part_2(510, {10, 10}) == 45
    end

    @tag skip: true
    test "puzzle input" do
      assert Day22.part_2(4848, {15, 700}) == 11359
    end
  end
end
