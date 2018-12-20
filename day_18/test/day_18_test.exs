defmodule Day18Test do
  use ExUnit.Case
  doctest Day18

  describe "part 1" do
    test "example" do
      input = """
      .#.#...|#.
      .....#|##|
      .|..|...#.
      ..|#.....#
      #.#|||#|#|
      ...#.||...
      .|....|...
      ||...#|.#|
      |.||||..|.
      ...#.|..|.
      """

      assert Day18.part_1(input) == 1147
    end
  end
end
