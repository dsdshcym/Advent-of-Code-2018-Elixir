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

  describe "part 2" do
    test "example" do
      input = """
      pos=<10,12,12>, r=2
      pos=<12,14,12>, r=2
      pos=<16,12,12>, r=4
      pos=<14,14,14>, r=6
      pos=<50,50,50>, r=200
      pos=<10,10,10>, r=5
      """

      assert Day23.part_2(input) == 36
    end

    test "puzzle input" do
      assert Day23.part_2(@puzzle_input) == 47_141_479
    end
  end
end
