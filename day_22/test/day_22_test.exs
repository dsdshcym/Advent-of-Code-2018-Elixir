defmodule Day22Test do
  use ExUnit.Case
  doctest Day22

  describe "part 1" do
    test "example" do
      assert Day22.part_1(510, {10, 10}) == 114
    end

    @tag skip: true
    test "puzzle input" do
      assert Day22.part_1(4848, {15, 700}) == 1
    end
  end

  describe "risk_level/3" do
    test "examples" do
      assert Day22.risk_level(510, {0, 0}, {10, 10}) == 0
      assert Day22.risk_level(510, {1, 0}, {10, 10}) == 1
      assert Day22.risk_level(510, {0, 1}, {10, 10}) == 0
      assert Day22.risk_level(510, {1, 1}, {10, 10}) == 2
      assert Day22.risk_level(510, {10, 10}, {10, 10}) == 0
    end
  end
end
