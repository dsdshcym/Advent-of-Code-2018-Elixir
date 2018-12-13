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
    topological_sort(edges, all_steps(edges))
  end

  defp topological_sort([], steps) do
    steps |> Enum.sort()
  end

  defp topological_sort(edges, steps) do
    [first_ready_step | _others] = next_steps(edges, steps)

    remain_edges =
      edges
      |> Enum.reject(fn {prerequisite, _} -> prerequisite == first_ready_step end)

    remain_steps = steps -- [first_ready_step]

    [first_ready_step | topological_sort(remain_edges, remain_steps)]
  end

  def work_with_help_from_elves(_edges, _steps = [], _workers, seconds) do
    seconds
  end

  def work_with_help_from_elves(edges, steps, status, seconds) do
    {new_status, finished_steps} =
      status
      |> dispatch(next_steps(edges, steps))
      |> work()

    remain_edges =
      edges
      |> Enum.reject(fn {prerequisite, _} -> prerequisite in finished_steps end)

    remain_steps = steps -- finished_steps

    work_with_help_from_elves(remain_edges, remain_steps, new_status, seconds + 1)
  end

  def dispatch(status, steps) do
    working_steps =
      status
      |> Enum.reduce([], fn
        {_, {step, _}}, working_steps -> [step | working_steps]
        {_, nil}, working_steps -> working_steps
      end)

    do_dispatch(status, steps -- working_steps)
  end

  defp do_dispatch([], _steps) do
    []
  end

  defp do_dispatch(status, []) do
    status
  end

  defp do_dispatch([{worker, nil} | status_tail], [step | steps_tail]) do
    [{worker, {step, initial_seconds(step)}} | do_dispatch(status_tail, steps_tail)]
  end

  defp do_dispatch([working | status_tail], steps) do
    [working | do_dispatch(status_tail, steps)]
  end

  defp initial_seconds(<<step::utf8>>) do
    60 + step - ?A + 1
  end

  def work(status) do
    status
    |> Enum.map(fn
      {worker, {finished_step, remaining_seconds}} ->
        {worker, {finished_step, remaining_seconds - 1}}

      idle_worker ->
        idle_worker
    end)
    |> Enum.map_reduce([], fn
      {worker, {finished_step, 0}}, finished_steps ->
        {{worker, nil}, [finished_step | finished_steps]}

      unfinished_work, finished_steps ->
        {unfinished_work, finished_steps}
    end)
  end

  def all_steps(edges) do
    edges |> Enum.flat_map(&Tuple.to_list/1) |> Enum.uniq()
  end

  defp next_steps([], steps) do
    steps
  end

  defp next_steps(edges, steps) do
    steps
    |> Enum.filter(fn ready_step ->
      Enum.all?(edges, fn {_prerequisite, step} -> step != ready_step end)
    end)
    |> Enum.sort()
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

  describe "work_with_help_from_elves" do
    @tag skip: true
    test "returns seconds when remaining_steps are none" do
      remaining_edges = []
      remaining_steps = []

      assert KitInstructions.work_with_help_from_elves(
               remaining_edges,
               remaining_steps,
               [],
               1
             ) == 1
    end

    @tag skip: true
    test "finishes a step in one second" do
      remaining_edges = []
      remaining_steps = ["E"]

      assert KitInstructions.work_with_help_from_elves(
               remaining_edges,
               remaining_steps,
               [worker1: {"E", 1}],
               14
             ) == 15
    end

    @tag skip: true
    test "finishes a step in several seconds" do
      remaining_edges = []
      remaining_steps = ["E"]

      assert KitInstructions.work_with_help_from_elves(
               remaining_edges,
               remaining_steps,
               [worker1: {"E", 2}],
               13
             ) == 15
    end

    @tag skip: true
    test "picks a new step after one is finished" do
      remaining_edges = [{"D", "E"}]
      remaining_steps = ["E", "D"]

      assert KitInstructions.work_with_help_from_elves(
               remaining_edges,
               remaining_steps,
               [worker1: {"D", 2}],
               8
             ) == 15
    end

    @tag skip: true
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

      edges =
        input
        |> KitInstructions.parse()

      steps = KitInstructions.all_steps(edges)

      assert KitInstructions.work_with_help_from_elves(
               edges,
               steps,
               [worker1: nil, worker2: nil],
               0
             ) == 15
    end

    test "puzzle input" do
      edges =
        @input
        |> KitInstructions.parse()

      steps = KitInstructions.all_steps(edges)

      assert KitInstructions.work_with_help_from_elves(
               edges,
               steps,
               [worker1: nil, worker2: nil, worker3: nil, worker4: nil, worker5: nil],
               0
             ) == 898
    end
  end

  describe "work/1" do
    test "reduces unfinished steps counter by 1" do
      assert {[worker1: {"E", 1}], _finished_steps} = KitInstructions.work(%{worker1: {"E", 2}})
    end

    test "returns new status with finished steps removed" do
      assert {[worker1: nil], _finished_steps} = KitInstructions.work(%{worker1: {"E", 1}})
    end

    test "returns finished steps" do
      assert {_new_status, ["E"]} = KitInstructions.work(%{worker1: {"E", 1}})
    end
  end

  describe "dispatch/2" do
    test "returns original status for empty next_steps" do
      assert [worker1: nil] == KitInstructions.dispatch([worker1: nil], [])
    end

    test "returns original status if all workers are working" do
      assert [worker1: {"E", 1}] == KitInstructions.dispatch([worker1: {"E", 1}], ["A"])
    end

    test "dispatches for all workers" do
      assert [worker1: {"E", 5}] == KitInstructions.dispatch([worker1: nil], ["E", "A"])
    end

    test "does not dispatch a step when a worker is working on it" do
      assert [worker1: nil, worker2: {"E", 3}] ==
               KitInstructions.dispatch([worker1: nil, worker2: {"E", 3}], ["E"])
    end
  end
end
