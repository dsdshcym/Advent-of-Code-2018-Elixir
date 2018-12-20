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

  describe "parse/1" do
    test "trims input first" do
      assert Day18.parse("    ") == %{}
    end

    test "replaces . with :open" do
      assert Day18.parse(".") == %{{0, 0} => :open}
    end

    test "replaces # with :trees" do
      assert Day18.parse("#") == %{{0, 0} => :trees}
    end

    test "replaces | with :lumberyard" do
      assert Day18.parse("|") == %{{0, 0} => :lumberyard}
    end

    test "multiple lines" do
      assert Day18.parse("...\n###\n|||") == %{
               {0, 0} => :open,
               {1, 0} => :open,
               {2, 0} => :open,
               {0, 1} => :trees,
               {1, 1} => :trees,
               {2, 1} => :trees,
               {0, 2} => :lumberyard,
               {1, 2} => :lumberyard,
               {2, 2} => :lumberyard
             }
    end
  end
end
