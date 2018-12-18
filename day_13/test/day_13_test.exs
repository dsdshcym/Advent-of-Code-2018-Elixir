defmodule Day13Test do
  use ExUnit.Case
  doctest Day13

  describe "parse/1" do
    test "stores tracks in a map" do
      assert Day13.parse("/-\\").tracks == %{{0, 0} => "/", {1, 0} => "-", {2, 0} => "\\"}
    end

    test "filters out empty grounds" do
      assert Day13.parse(" - ").tracks == %{{1, 0} => "-"}
    end

    test "replaces < with - in tracks" do
      assert Day13.parse("<").tracks == %{{0, 0} => "-"}
    end

    test "replaces > with - in tracks" do
      assert Day13.parse(">").tracks == %{{0, 0} => "-"}
    end

    test "replaces v with | in tracks" do
      assert Day13.parse("v").tracks == %{{0, 0} => "|"}
    end

    test "replaces ^ with | in tracks" do
      assert Day13.parse("^").tracks == %{{0, 0} => "|"}
    end

    test "stores carts with their locations, directions, and turn_option info" do
      assert Day13.parse("<>^v").carts == [
               %{pos: {0, 0}, direction: "<", turn_option: :left},
               %{pos: {1, 0}, direction: ">", turn_option: :left},
               %{pos: {2, 0}, direction: "^", turn_option: :left},
               %{pos: {3, 0}, direction: "v", turn_option: :left}
             ]
    end
  end
end
