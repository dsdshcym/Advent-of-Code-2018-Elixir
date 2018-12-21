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

  describe "parse_samples/1" do
    test "parses before list" do
      input = """
      Before: [1, 2, 3, 4]
      0 0 0 0
      After:  [0, 0, 0, 0]
      """

      assert [%{before: [1, 2, 3, 4]}] = Day16.parse_samples(input)
    end

    test "parses instruction map" do
      input = """
      Before: [0, 0, 0, 0]
      15 1 3 2
      After:  [0, 0, 0, 0]
      """

      assert [%{instruction: %{opcode: 15, A: 1, B: 3, C: 2}}] = Day16.parse_samples(input)
    end

    test "parses after list" do
      input = """
      Before: [0, 0, 0, 0]
      0 0 0 0
      After:  [923, 82, 789, 654]
      """

      assert [%{after: [923, 82, 789, 654]}] = Day16.parse_samples(input)
    end

    test "parses multiple samples separated by an empty line" do
      input = """
      Before: [3, 2, 2, 3]
      3 1 1 0
      After:  [1, 2, 2, 3]

      Before: [0, 1, 2, 3]
      5 1 0 0
      After:  [1, 1, 2, 3]
      """

      assert [
               %{
                 before: [3, 2, 2, 3],
                 instruction: %{opcode: 3, A: 1, B: 1, C: 0},
                 after: [1, 2, 2, 3]
               },
               %{
                 before: [0, 1, 2, 3],
                 instruction: %{opcode: 5, A: 1, B: 0, C: 0},
                 after: [1, 1, 2, 3]
               }
             ] = Day16.parse_samples(input)
    end
  end
end
