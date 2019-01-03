defmodule Day20Test do
  use ExUnit.Case
  doctest Day20

  @puzzle_input File.read!("./test/fixtures/puzzle_input.txt") |> String.trim()

  describe "part_1/1" do
    test "examples" do
      assert Day20.part_1("^WNE$") == 3
      assert Day20.part_1("^ENWWW(NEEE|SSE(EE|N))$") == 10
      assert Day20.part_1("^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$") == 18
      assert Day20.part_1("^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$") == 23

      assert Day20.part_1("^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$") ==
               31
    end

    test "puzzle input" do
      assert Day20.part_1(@puzzle_input) == 4344
    end

    test "circle" do
      assert Day20.part_1("^N(ENWS|W)$") == 3
    end
  end

  describe "parse_input/1" do
    test "ignores ^ and $" do
      assert Day20.parse_input("^$") == []
    end

    test "replaces N with :north" do
      assert Day20.parse_input("^N$") == [:north]
    end

    test "replaces W with :west" do
      assert Day20.parse_input("^W$") == [:west]
    end

    test "replaces S with :south" do
      assert Day20.parse_input("^S$") == [:south]
    end

    test "replaces E with :east" do
      assert Day20.parse_input("^E$") == [:east]
    end

    test "multiple instructions" do
      assert Day20.parse_input("^WNES$") == [:west, :north, :east, :south]
    end

    test "handles non-splitted branch" do
      assert Day20.parse_input("^E(NS)W$") == [:east, [[:north, :south]], :west]
    end

    test "handles non-nested branch" do
      assert Day20.parse_input("^E(N|S)W$") == [:east, [[:north], [:south]], :west]
    end

    test "handles empty branch" do
      assert Day20.parse_input("^E()W$") == [:east, [[]], :west]
    end

    test "nested branches" do
      assert Day20.parse_input("^E(N(W|E))W$") == [:east, [[:north, [[:west], [:east]]]], :west]

      assert Day20.parse_input("^E(N(W|E)|S(E|W))W$") == [
               :east,
               [[:north, [[:west], [:east]]], [:south, [[:east], [:west]]]],
               :west
             ]
    end
  end

  describe "build_map/1" do
    test "returns empty map if no routes" do
      assert Day20.build_map([]) == %{}
    end

    test "returns neighbors info" do
      assert Day20.build_map([:north]) == %{
               {0, 0} => MapSet.new([{0, 1}]),
               {0, 1} => MapSet.new([{0, 0}])
             }
    end

    test "handles branches" do
      assert Day20.build_map([[[:north], [:south]]]) == %{
               {0, 0} => MapSet.new([{0, 1}, {0, -1}]),
               {0, 1} => MapSet.new([{0, 0}]),
               {0, -1} => MapSet.new([{0, 0}])
             }
    end

    test "moves from different start after branches" do
      assert Day20.build_map([[[:north], [:south]], :west]) == %{
               {0, 0} => MapSet.new([{0, 1}, {0, -1}]),
               {0, 1} => MapSet.new([{0, 0}, {-1, 1}]),
               {0, -1} => MapSet.new([{0, 0}, {-1, -1}]),
               {-1, 1} => MapSet.new([{0, 1}]),
               {-1, -1} => MapSet.new([{0, -1}])
             }
    end

    test "handles empty branch" do
      assert Day20.build_map([[[:north], []], :west]) == %{
               {0, 0} => MapSet.new([{0, 1}, {-1, 0}]),
               {0, 1} => MapSet.new([{0, 0}, {-1, 1}]),
               {-1, 0} => MapSet.new([{0, 0}]),
               {-1, 1} => MapSet.new([{0, 1}])
             }
    end
  end

  describe "furthest_distance/2" do
    test "returns 1 if only one neighbor" do
      map = %{{0, 0} => MapSet.new([{0, 1}]), {0, 1} => MapSet.new([{0, 0}])}

      assert Day20.furthest_distance(map, {0, 0}) == 1
    end
  end
end
