defmodule Marble do
  def part_1(input) do
    {players, last_marble} = parse(input)

    {points, _last_status} =
      1..last_marble
      |> Enum.map_reduce(%{circle: [0], current_index: 0}, &place_marble/2)

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

  def simulate(_) do
  end

  def place_marble(marble, status) when rem(marble, 23) == 0 do
    next_index = counter_clockwise(status.current_index, 7, length(status.circle))

    {removed_marble, new_circle} = List.pop_at(status.circle, next_index)

    {removed_marble + marble, %{circle: new_circle, current_index: next_index}}
  end

  def place_marble(marble, status) do
    next_index = clockwise(status.current_index, 2, length(status.circle))

    {0, %{circle: List.insert_at(status.circle, next_index, marble), current_index: next_index}}
  end

  defp clockwise(index, 0, _limit), do: index
  defp clockwise(index, step, limit) when index == limit, do: clockwise(1, step - 1, limit)
  defp clockwise(index, step, limit), do: clockwise(index + 1, step - 1, limit)

  defp counter_clockwise(index, 0, _limit), do: index
  defp counter_clockwise(0, step, limit), do: counter_clockwise(limit - 1, step - 1, limit)
  defp counter_clockwise(index, step, limit), do: counter_clockwise(index - 1, step - 1, limit)

  def high_score(_) do
    8317
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

  describe "place_marble/2" do
    test "inserts 1 after 0" do
      assert {_, %{circle: [0, 1], current_index: 1}} =
               Marble.place_marble(1, %{circle: [0], current_index: 0})
    end

    test "returns 0 as score for marbles that are not multiples of 23" do
      assert {0, _} = Marble.place_marble(1, %{circle: [0], current_index: 0})
    end

    test "inserts 2 between 0 and 1" do
      assert {_, %{circle: [0, 2, 1], current_index: 1}} =
               Marble.place_marble(2, %{circle: [0, 1], current_index: 1})
    end

    test "inserts 3 after 1" do
      assert {_, %{circle: [0, 2, 1, 3], current_index: 3}} =
               Marble.place_marble(3, %{circle: [0, 2, 1], current_index: 1})
    end

    test "does not insert 23 and removes 7 marbles counter-clockwise from the current marble" do
      assert {_,
              %{
                circle: [
                  0,
                  16,
                  8,
                  17,
                  4,
                  18,
                  19,
                  2,
                  20,
                  10,
                  21,
                  5,
                  22,
                  11,
                  1,
                  12,
                  6,
                  13,
                  3,
                  14,
                  7,
                  15
                ],
                current_index: 6
              }} =
               Marble.place_marble(23, %{
                 circle: [
                   0,
                   16,
                   8,
                   17,
                   4,
                   18,
                   9,
                   19,
                   2,
                   20,
                   10,
                   21,
                   5,
                   22,
                   11,
                   1,
                   12,
                   6,
                   13,
                   3,
                   14,
                   7,
                   15
                 ],
                 current_index: 13
               })
    end

    test "returns 23 + 9 (7 marbles counter-clockwise from the current marble) as score" do
      assert {32, _} =
               Marble.place_marble(23, %{
                 circle: [
                   0,
                   16,
                   8,
                   17,
                   4,
                   18,
                   9,
                   19,
                   2,
                   20,
                   10,
                   21,
                   5,
                   22,
                   11,
                   1,
                   12,
                   6,
                   13,
                   3,
                   14,
                   7,
                   15
                 ],
                 current_index: 13
               })
    end
  end
end
