defmodule Marble do
  defmodule Circle do
    defstruct left_stack: [], current: nil, right_queue: []

    def traverse_clockwisely(circle, 0) do
      circle
    end

    def traverse_clockwisely(%{left_stack: [], right_queue: []} = circle, _step) do
      circle
    end

    def traverse_clockwisely(%{right_queue: [new_current | new_right_queue]} = circle, step) do
      %__MODULE__{
        left_stack: [circle.current | circle.left_stack],
        current: new_current,
        right_queue: new_right_queue
      }
      |> traverse_clockwisely(step - 1)
    end

    def traverse_clockwisely(%{right_queue: []} = circle, step) do
      traverse_clockwisely(
        %{circle | left_stack: [], right_queue: Enum.reverse(circle.left_stack)},
        step
      )
    end

    def traverse_counter_clockwisely(circle, 0) do
      circle
    end

    def traverse_counter_clockwisely(%{left_stack: [], right_queue: []} = circle, _step) do
      circle
    end

    def traverse_counter_clockwisely(%{left_stack: []} = circle, step) do
      traverse_counter_clockwisely(
        %{circle | left_stack: Enum.reverse(circle.right_queue), right_queue: []},
        step
      )
    end

    def traverse_counter_clockwisely(circle, step) do
      [new_current | new_left_stack] = circle.left_stack

      %__MODULE__{
        left_stack: new_left_stack,
        current: new_current,
        right_queue: [circle.current | circle.right_queue]
      }
      |> traverse_counter_clockwisely(step - 1)
    end

    def pop(%{right_queue: []} = circle) do
      pop(%{circle | left_stack: circle.right_queue, right_queue: circle.left_stack})
    end

    def pop(%{right_queue: [new_current | new_right_queue]} = circle) do
      {circle.current, %{circle | right_queue: new_right_queue, current: new_current}}
    end

    def insert(circle, value) do
      %{circle | right_queue: [circle.current | circle.right_queue], current: value}
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

  describe "part 2" do
    test "puzzle input" do
      assert Marble.part_1("410 players; last marble is worth 7205900 points") == 3_624_387_659
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
