defmodule KitInstructions do
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(<<
         "Step ",
         prerequisite::binary-size(1),
         " must be finished before step ",
         step::binary-size(1),
         " can begin."
       >>) do
    {prerequisite, step}
  end

  def topological_sort(edges) do
    all_steps = edges |> Enum.flat_map(&Tuple.to_list/1) |> Enum.uniq()

    topological_sort(edges, all_steps)
  end

  defp topological_sort([], steps) do
    steps |> Enum.sort()
  end

  defp topological_sort(edges, steps) do
    first_ready_step = first_ready_step(edges, steps)

    remain_edges =
      edges
      |> Enum.reject(fn {prerequisite, _} -> prerequisite == first_ready_step end)

    remain_steps = steps -- [first_ready_step]

    [first_ready_step | topological_sort(remain_edges, remain_steps)]
  end

  defp first_ready_step(edges, steps) do
    [first_ready_step | _others] =
      steps
      |> Enum.filter(fn ready_step ->
        Enum.all?(edges, fn {_prerequisite, step} -> step != ready_step end)
      end)
      |> Enum.sort()

    first_ready_step
  end
end

ExUnit.start()

defmodule KitInstructionsTest do
  use ExUnit.Case

  describe "parse/1" do
    test "single line" do
      input = "Step C must be finished before step A can begin."

      assert KitInstructions.parse(input) == [{"C", "A"}]
    end

    test "multiple lines" do
      input = """
      Step C must be finished before step A can begin.
      Step C must be finished before step F can begin.
      """

      assert KitInstructions.parse(input) == [{"C", "A"}, {"C", "F"}]
    end
  end

  describe "topological_sort/1" do
    test "one edge" do
      assert KitInstructions.topological_sort([{"A", "B"}]) == ["A", "B"]
    end

    test "single line" do
      assert KitInstructions.topological_sort([
               {"B", "C"},
               {"A", "B"}
             ]) == ["A", "B", "C"]
    end

    test "more than one step is ready in the end" do
      assert KitInstructions.topological_sort([
               {"A", "C"},
               {"A", "B"}
             ]) == ["A", "B", "C"]
    end

    test "more than one step is ready in the middle" do
      assert KitInstructions.topological_sort([
               {"B", "C"},
               {"A", "C"}
             ]) == ["A", "B", "C"]
    end
  end

  @input File.read!("./fixtures/day_7.txt")

  describe "part 1" do
    test "example" do
      input = """
      Step C must be finished before step A can begin.
      Step C must be finished before step F can begin.
      Step A must be finished before step B can begin.
      Step A must be finished before step D can begin.
      Step B must be finished before step E can begin.
      Step D must be finished before step E can begin.
      Step F must be finished before step E can begin.
      """

      assert input
             |> KitInstructions.parse()
             |> KitInstructions.topological_sort()
             |> Enum.join() == "CABDFE"
    end

    test "puzzle input" do
      assert @input
             |> KitInstructions.parse()
             |> KitInstructions.topological_sort()
             |> Enum.join() == "ABGKCMVWYDEHFOPQUILSTNZRJX"
    end
  end
end
