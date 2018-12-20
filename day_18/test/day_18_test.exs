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

  describe "tick/3" do
    test "it returns landscape if minutes is zero" do
      assert Day18.tick(:any_landscape, 0, fn _ -> nil end) == :any_landscape
    end

    test "it calls tick reductively minutes times" do
      tick_fun = fn
        :init_landscape -> :second_landscape
        :second_landscape -> :final_landscape
      end

      assert Day18.tick(:init_landscape, 2, tick_fun) == :final_landscape
    end
  end

  describe "tick/1" do
    test "an open acre will become filled with trees if three or more adjacent acres contained trees." do
      landscape = %{
        {0, 0} => :trees,
        {1, 0} => :trees,
        {2, 0} => :trees,
        {0, 1} => :lumberyard,
        {1, 1} => :open,
        {2, 1} => :lumberyard,
        {0, 2} => :lumberyard,
        {1, 2} => :lumberyard,
        {2, 2} => :lumberyard
      }

      assert %{{1, 1} => :trees} = Day18.tick(landscape)
    end

    test "an open acre will remain the same if two or less adjacent acres contained trees." do
      landscape = %{
        {0, 0} => :trees,
        {1, 0} => :trees,
        {2, 0} => :lumberyard,
        {0, 1} => :lumberyard,
        {1, 1} => :open,
        {2, 1} => :lumberyard,
        {0, 2} => :lumberyard,
        {1, 2} => :lumberyard,
        {2, 2} => :lumberyard
      }

      assert %{{1, 1} => :open} = Day18.tick(landscape)
    end

    test "an acre filled with trees will become a lumberyard if three or more adjacent acres were lumberyards." do
      landscape = %{
        {0, 0} => :lumberyard,
        {1, 0} => :lumberyard,
        {2, 0} => :lumberyard,
        {0, 1} => :open,
        {1, 1} => :trees,
        {2, 1} => :open,
        {0, 2} => :open,
        {1, 2} => :open,
        {2, 2} => :open
      }

      assert %{{1, 1} => :lumberyard} = Day18.tick(landscape)
    end

    test "an acre filled with trees will remain the same if two or less adjacent acres were lumberyards." do
      landscape = %{
        {0, 0} => :lumberyard,
        {1, 0} => :lumberyard,
        {2, 0} => :open,
        {0, 1} => :open,
        {1, 1} => :trees,
        {2, 1} => :open,
        {0, 2} => :open,
        {1, 2} => :open,
        {2, 2} => :open
      }

      assert %{{1, 1} => :trees} = Day18.tick(landscape)
    end

    test "an acre containing a lumberyard will remain a lumberyard if it was adjacent to at least one other lumberyard and at least one acre containing trees." do
      landscape = %{
        {0, 0} => :lumberyard,
        {1, 0} => :trees,
        {2, 0} => :open,
        {0, 1} => :open,
        {1, 1} => :lumberyard,
        {2, 1} => :open,
        {0, 2} => :open,
        {1, 2} => :open,
        {2, 2} => :open
      }

      assert %{{1, 1} => :lumberyard} = Day18.tick(landscape)
    end

    test "an acre containing a lumberyard will become open if it was not adjacent to any lumberyard" do
      landscape = %{
        {0, 0} => :trees,
        {1, 0} => :trees,
        {2, 0} => :trees,
        {0, 1} => :trees,
        {1, 1} => :lumberyard,
        {2, 1} => :trees,
        {0, 2} => :trees,
        {1, 2} => :trees,
        {2, 2} => :trees
      }

      assert %{{1, 1} => :open} = Day18.tick(landscape)
    end

    test "an acre containing a lumberyard will become open if it was not adjacent to any trees" do
      landscape = %{
        {0, 0} => :lumberyard,
        {1, 0} => :lumberyard,
        {2, 0} => :lumberyard,
        {0, 1} => :lumberyard,
        {1, 1} => :lumberyard,
        {2, 1} => :lumberyard,
        {0, 2} => :lumberyard,
        {1, 2} => :lumberyard,
        {2, 2} => :lumberyard
      }

      assert %{{1, 1} => :open} = Day18.tick(landscape)
    end

    test "does not count missing acres that are out side of the landscape" do
      landscape = %{
        {0, 0} => :trees,
        {1, 0} => :lumberyard,
        {0, 1} => :lumberyard,
        {1, 1} => :lumberyard
      }

      assert %{{0, 0} => :lumberyard} = Day18.tick(landscape)
    end
  end
end
