defmodule Day16Test do
  use ExUnit.Case
  doctest Day16

  describe "part 1" do
    test "example" do
      input = """
      Before: [3, 2, 1, 1]
      9 2 1 2
      After:  [3, 2, 2, 1]
      """

      assert input
             |> Day16.possible_opcodes_for_every_sample()
             |> Enum.count(&(length(&1) >= 3)) == 1
    end
  end
end
