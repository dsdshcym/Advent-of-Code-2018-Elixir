defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  describe "parse/1" do
    test "single line" do
      assert Day10.parse("position=< 9,  1> velocity=< 0,  2>") == [{9, 1, 0, 2}]
    end

    test "multiple lines" do
      assert Day10.parse("""
             position=< 9,  1> velocity=< 0,  2>
             position=< 7,  0> velocity=< 1,  0>
             """) ==
               [
                 {9, 1, 0, 2},
                 {7, 0, 1, 0}
               ]
    end

    test "negative integers" do
      assert Day10.parse("position=<-3, -11> velocity=<-1, -2>") == [{-3, -11, -1, -2}]
    end

    test "long integers" do
      assert Day10.parse("position=<123, 7890> velocity=<-456, -2345>") ==
               [{123, 7890, -456, -2345}]
    end
  end

  describe "tick/1" do
    test "moves every points" do
      assert Day10.tick([
               {1, 2, -1, 3}
             ]) == [
               {0, 5, -1, 3}
             ]
    end
  end

  describe "to_s/1" do
    test "" do
      assert Day10.to_s([
               {1, 2, 12, 34}
             ]) == "...\n.#.\n..."
    end
  end
end
