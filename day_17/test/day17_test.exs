defmodule Day17Test do
  use ExUnit.Case
  doctest Day17

  @puzzle_input File.read!("./test/puzzle_input.txt")

  describe "part 1" do
    test "example" do
      input = """
      x=495, y=2..7
      y=7, x=495..501
      x=501, y=3..7
      x=498, y=2..4
      x=506, y=1..2
      x=498, y=10..13
      x=504, y=10..13
      y=13, x=498..504
      """

      assert Day17.part_1(input) == 57
    end

    test "puzzle input" do
      assert Day17.part_1(@puzzle_input) == 39557
    end
  end
end
