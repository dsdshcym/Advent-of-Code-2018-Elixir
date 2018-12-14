defmodule Marble do
  defmodule Circle do
    defstruct left: [], current: nil, right: []

    def traverse_clockwisely(circle, 0) do
      circle
    end

    def traverse_clockwisely(%{left: [], right: []} = circle, _step) do
      circle
    end

    def traverse_clockwisely(%{right: [new_current | new_right]} = circle, step) do
      %__MODULE__{
        left: circle.left ++ [circle.current],
        current: new_current,
        right: new_right
      }
      |> traverse_clockwisely(step - 1)
    end

    def traverse_clockwisely(%{right: []} = circle, step) do
      traverse_clockwisely(%{circle | left: circle.right, right: circle.left}, step)
    end

    def traverse_counter_clockwisely(circle, 0) do
      circle
    end

    def traverse_counter_clockwisely(%{left: [], right: []} = circle, _step) do
      circle
    end

    def traverse_counter_clockwisely(%{left: []} = circle, step) do
      traverse_counter_clockwisely(%{circle | left: circle.right, right: []}, step)
    end

    def traverse_counter_clockwisely(circle, step) do
      {new_current, new_left} = List.pop_at(circle.left, -1)

      %__MODULE__{
        left: new_left,
        current: new_current,
        right: [circle.current | circle.right]
      }
      |> traverse_counter_clockwisely(step - 1)
    end

    def pop(%{right: []} = circle) do
      pop(%{circle | left: circle.right, right: circle.left})
    end

    def pop(%{right: [new_current | new_right]} = circle) do
      {circle.current, %{circle | right: new_right, current: new_current}}
    end

    def insert(circle, value) do
      %{circle | right: [circle.current | circle.right], current: value}
    end
  end

  def part_1(input) do
    {players, last_marble} = parse(input)

    {points, _last_status} =
      1..last_marble
      |> Enum.map_reduce(%Circle{current: 0}, &place_marble/2)

    {_player, high_score} =
      1..players
      |> Enum.to_list()
      |> Stream.cycle()
      |> Enum.zip(points)
      |> Enum.group_by(fn {player, _score} -> player end, fn {_player, score} -> score end)
      |> Enum.map(fn {player, scores} -> {player, Enum.sum(scores)} end)
      |> Enum.max_by(fn {_player, total_score} -> total_score end)

    high_score
  end

  def parse(input) do
    [players, "players;", "last", "marble", "is", "worth", last_marble, "points"] =
      String.split(input)

    {String.to_integer(players), String.to_integer(last_marble)}
  end

  def place_marble(marble, circle) when rem(marble, 23) == 0 do
    {removed_marble, new_circle} =
      circle
      |> Circle.traverse_counter_clockwisely(7)
      |> Circle.pop()

    {removed_marble + marble, new_circle}
  end

  def place_marble(marble, circle) do
    new_circle =
      circle
      |> Circle.traverse_clockwisely(2)
      |> Circle.insert(marble)

    {0, new_circle}
  end
end

ExUnit.start()

defmodule MarbleTest do
  use ExUnit.Case

  @input "410 players; last marble is worth 72059 points"

  describe "part 1" do
    test "examples" do
      assert Marble.part_1("9 players; last marble is worth 25 points") == 32
      assert Marble.part_1("10 players; last marble is worth 1618 points") == 8317
      assert Marble.part_1("13 players; last marble is worth 7999 points") == 146_373
      assert Marble.part_1("17 players; last marble is worth 1104 points") == 2764
      assert Marble.part_1("21 players; last marble is worth 6111 points") == 54718
      assert Marble.part_1("30 players; last marble is worth 5807 points") == 37305
    end

    test "puzzle input" do
      assert Marble.part_1(@input) == 429_287
    end
  end

  describe "parse/1" do
    test "returns players" do
      assert {10, _} = Marble.parse("10 players; last marble is worth 1618 points")
    end

    test "returns last_marble" do
      assert {_, 1618} = Marble.parse("10 players; last marble is worth 1618 points")
    end
  end
end

defmodule Marble.CircleTest do
  use ExUnit.Case

  alias Marble.Circle

  describe "traverse_clockwisely/2" do
    test "returns circle when step is 0" do
      assert Circle.traverse_clockwisely(%Circle{}, 0) == %Circle{}
    end

    test "returns circle when it has only one item (current)" do
      assert Circle.traverse_clockwisely(%Circle{left: [], right: [], current: 100}, 329) ==
               %Circle{left: [], right: [], current: 100}
    end

    test "sets current to the first item of right when right is not empty" do
      assert %Circle{current: 1} = Circle.traverse_clockwisely(%Circle{right: [1, 2]}, 1)
    end

    test "pops first item of right when right is not empty" do
      assert %Circle{right: [2]} = Circle.traverse_clockwisely(%Circle{right: [1, 2]}, 1)
    end

    test "pushes old current to the end of left when right is not empty" do
      assert %Circle{left: [0, 1]} =
               Circle.traverse_clockwisely(%Circle{left: [0], current: 1, right: [2]}, 1)
    end

    test "cycles when right is empty" do
      assert %Circle{left: [2], current: 0, right: [1]} =
               Circle.traverse_clockwisely(%Circle{left: [0, 1], current: 2, right: []}, 1)
    end

    test "runs recursively until step is 0" do
      assert %Circle{left: [1], current: 2, right: [0]} =
               Circle.traverse_clockwisely(%Circle{left: [0, 1], current: 2, right: []}, 3)
    end
  end

  describe "traverse_counter_clockwisely/2" do
    test "returns circle when step is 0" do
      assert Circle.traverse_counter_clockwisely(%Circle{}, 0) == %Circle{}
    end

    test "returns circle when it has only one item (current)" do
      assert Circle.traverse_counter_clockwisely(%Circle{left: [], right: [], current: 23}, 23) ==
               %Circle{left: [], right: [], current: 23}
    end

    test "sets current to the last item of left when left is not empty" do
      assert %Circle{current: 1} = Circle.traverse_counter_clockwisely(%Circle{left: [2, 1]}, 1)
    end

    test "pops last item of left when left is not empty" do
      assert %Circle{left: [2]} = Circle.traverse_counter_clockwisely(%Circle{left: [2, 1]}, 1)
    end

    test "pushes old current to the beginning of right" do
      assert %Circle{right: [3, 4, 5]} =
               Circle.traverse_counter_clockwisely(
                 %Circle{left: [1], current: 3, right: [4, 5]},
                 1
               )
    end

    test "cycles when left is empty" do
      assert %Circle{left: [2], current: 3, right: [1]} =
               Circle.traverse_counter_clockwisely(
                 %Circle{left: [], current: 1, right: [2, 3]},
                 1
               )
    end

    test "runs recursively until step is 0" do
      assert %Circle{left: [2], current: 3, right: [1]} =
               Circle.traverse_counter_clockwisely(
                 %Circle{left: [1], current: 2, right: [3]},
                 2
               )
    end
  end

  describe "pop/1" do
    test "returns current as the popped value" do
      assert {1, _} = Circle.pop(%Circle{current: 1, right: [0]})
    end

    test "sets current to the first item of right when right is not empty" do
      assert {_, %Circle{current: 1, right: [3]}} = Circle.pop(%Circle{right: [1, 3]})
    end

    test "sets current to the first item of left when right is empty" do
      assert {_, %Circle{current: 0, right: [2]}} = Circle.pop(%Circle{left: [0, 2], right: []})
    end
  end

  describe "insert/2" do
    test "moves current into right" do
      assert %Circle{right: [0]} = Circle.insert(%Circle{left: [], current: 0}, 1)
    end

    test "sets current to value" do
      assert %Circle{current: 1} = Circle.insert(%Circle{current: 0}, 1)
    end
  end
end
