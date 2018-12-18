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

  describe "tick/1" do
    test "moves cart forward in its current direction" do
      assert ">-" |> Day13.parse() |> Day13.tick() == "->" |> Day13.parse()
      assert "-<" |> Day13.parse() |> Day13.tick() == "<-" |> Day13.parse()
      assert "v\n|" |> Day13.parse() |> Day13.tick() == "|\nv" |> Day13.parse()
      assert "|\n^" |> Day13.parse() |> Day13.tick() == "^\n|" |> Day13.parse()
    end

    test "changes cart direction when it moves to a curve" do
      assert %{carts: [%{direction: "v"}]} = ">\\" |> Day13.parse() |> Day13.tick()
      assert %{carts: [%{direction: "<"}]} = "\\\n^" |> Day13.parse() |> Day13.tick()
      assert %{carts: [%{direction: ">"}]} = "v\n\\" |> Day13.parse() |> Day13.tick()
      assert %{carts: [%{direction: "^"}]} = "\\<" |> Day13.parse() |> Day13.tick()

      assert %{carts: [%{direction: "^"}]} = ">/" |> Day13.parse() |> Day13.tick()
      assert %{carts: [%{direction: ">"}]} = "/\n^" |> Day13.parse() |> Day13.tick()
      assert %{carts: [%{direction: "<"}]} = "v\n/" |> Day13.parse() |> Day13.tick()
      assert %{carts: [%{direction: "v"}]} = "/<" |> Day13.parse() |> Day13.tick()
    end

    test "changes cart direction based on turn_option when it moves to an intersection" do
      assert %{carts: [%{direction: "^"}]} = ">+" |> Day13.parse() |> Day13.tick()
    end

    test "updates cart turn_option when it moves to an intersection" do
      assert %{carts: [%{turn_option: :straight}]} = "+<" |> Day13.parse() |> Day13.tick()
    end
  end
end
