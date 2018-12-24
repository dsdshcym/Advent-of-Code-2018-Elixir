defmodule Day19Test do
  use ExUnit.Case
  doctest Day19

  describe "part 1" do
    test "example input" do
      input = """
      #ip 0
      seti 5 0 1
      seti 6 0 2
      addi 0 1 0
      addr 1 2 3
      setr 1 0 0
      seti 8 0 4
      seti 9 0 5
      """

      assert %{registers: [6, 5, 6, 0, 0, 9]} = Day19.part_1(input)
    end
  end
end
