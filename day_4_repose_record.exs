defmodule GuardRecords do
  def new(inputs) do
    inputs
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_log/1)
    |> sort_by_timestamp()
    |> build_records
  end

  defp parse_log(<<timestamp::binary-size(18), " ", rest::binary>>) do
    {parse_timestamp(timestamp), parse_action(rest)}
  end

  defp parse_timestamp(<<
         "[",
         year::binary-size(4),
         "-",
         month::binary-size(2),
         "-",
         day::binary-size(2),
         " ",
         hour::binary-size(2),
         ":",
         minute::binary-size(2),
         "]"
       >>) do
    {:ok, datetime} =
      NaiveDateTime.new(
        String.to_integer(year),
        String.to_integer(month),
        String.to_integer(day),
        String.to_integer(hour),
        String.to_integer(minute),
        0
      )

    datetime
  end

  defp parse_action("Guard #" <> guard_id_begins_shift) do
    {guard_id, " begins shift"} = Integer.parse(guard_id_begins_shift)

    {:begins_shift, guard_id}
  end

  defp parse_action("falls asleep") do
    :falls_asleep
  end

  defp parse_action("wakes up") do
    :wakes_up
  end

  defp sort_by_timestamp(logs) do
    Enum.sort_by(
      logs,
      fn {timestamp, _} -> timestamp end,
      fn ts1, ts2 -> NaiveDateTime.compare(ts1, ts2) != :gt end
    )
  end

  defp build_records(_logs, current_guard_id \\ nil, records \\ %{})

  defp build_records([], _current_guard_id, records) do
    records
  end

  defp build_records(
         [{_timestamp, {:begins_shift, guard_id}} | logs_tail],
         _current_guard_id,
         records
       ) do
    build_records(logs_tail, guard_id, records)
  end

  defp build_records(
         [{sleeps_at, :falls_asleep}, {wakes_at, :wakes_up} | logs_tail],
         current_guard_id,
         records
       )
       when is_integer(current_guard_id) do
    # Because all asleep/awake times are during the midnight hour
    # (00:00 - 00:59), only the minute portion (00 - 59) is relevant
    # for those events.
    duration = {sleeps_at.minute, wakes_at.minute - 1}

    build_records(
      logs_tail,
      current_guard_id,
      Map.update(records, current_guard_id, [duration], &[duration | &1])
    )
  end

  def guard_sleep_the_most(records) do
    records
    |> Enum.max_by(fn
      {_id, sleep_records} ->
        sleep_records
        |> Enum.map(fn {started_at, ended_at} -> ended_at - started_at + 1 end)
        |> Enum.sum()
    end)
    |> elem(0)
  end

  def choose_minute(records, guard) do
    sleep_records = records[guard]

    sleep_counts_by_minute =
      sleep_records
      |> Enum.reduce(%{}, fn {started_at, ended_at}, counts ->
        Enum.reduce(started_at..ended_at, counts, fn minute, counts ->
          Map.update(counts, minute, 1, &(&1 + 1))
        end)
      end)

    sleep_counts_by_minute
    |> Enum.max_by(fn {_minute, counts} -> counts end)
    |> elem(0)
  end
end

ExUnit.start()

defmodule GuardRecordsTest do
  use ExUnit.Case

  test "part 1" do
    puzzle_input = File.read!("./fixtures/day_4.txt")

    records = GuardRecords.new(puzzle_input)

    guard = GuardRecords.guard_sleep_the_most(records)
    minute = GuardRecords.choose_minute(records, guard)

    assert guard * minute == 67558
  end

  describe "new/1" do
    test "empty" do
      record = GuardRecords.new("")

      assert record == %{}
    end

    test "simple case" do
      record =
        GuardRecords.new("""
        [1518-11-01 00:00] Guard #10 begins shift
        [1518-11-01 00:05] falls asleep
        [1518-11-01 00:25] wakes up
        """)

      assert record == %{10 => [{05, 24}]}
    end

    test "guard starts before 00:00" do
      record =
        GuardRecords.new("""
        [1518-11-01 23:50] Guard #10 begins shift
        [1518-11-02 00:16] falls asleep
        [1518-11-02 00:29] wakes up
        """)

      assert record == %{10 => [{16, 28}]}
    end

    test "sorts by timestamp before processing" do
      record =
        GuardRecords.new("""
        [1518-11-01 00:05] falls asleep
        [1518-11-01 00:25] wakes up
        [1518-11-01 00:00] Guard #10 begins shift
        """)

      assert record == %{10 => [{05, 24}]}
    end
  end

  describe "guard_sleep_the_most/1" do
    test "returns the only id if only one guard" do
      records = %{1 => []}

      assert GuardRecords.guard_sleep_the_most(records) == 1
    end

    test "returns the id of whom sleeps the most" do
      records = %{
        1 => [{00, 49}],
        2 => [{01, 02}]
      }

      assert GuardRecords.guard_sleep_the_most(records) == 1
    end
  end

  describe "choose_minute/2" do
    test "returns the first overlapping minute of two time ranges" do
      records = %{2 => [{00, 10}, {10, 19}]}

      assert GuardRecords.choose_minute(records, 2) == 10
    end

    test "returns the most overlapped minute" do
      records = %{3 => [{00, 10}, {5, 11}, {10, 12}]}

      assert GuardRecords.choose_minute(records, 3) == 10
    end
  end
end
