defmodule Day23Test do
  use ExUnit.Case
  doctest Day23

  @puzzle_input File.read!("./test/puzzle_input.txt")

  describe "part 1" do
    test "example" do
      input = """
      pos=<0,0,0>, r=4
      pos=<1,0,0>, r=1
      pos=<4,0,0>, r=3
      pos=<0,2,0>, r=1
      pos=<0,5,0>, r=3
      pos=<0,0,3>, r=1
      pos=<1,1,1>, r=1
      pos=<1,1,2>, r=1
      pos=<1,3,1>, r=1
      """

      assert Day23.part_1(input) == 7
    end

    test "puzzle input" do
      assert Day23.part_1(@puzzle_input) == 481
    end
  end
end
