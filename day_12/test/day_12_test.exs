defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  @init_state '##....#.#.#...#.#..#.#####.#.#.##.#.#.#######...#.##....#..##....#.#..##.####.#..........#..#...#'

  @spread_notes %{
    '..#.#' => ?#,
    '.####' => ?#,
    '#....' => ?.,
    '####.' => ?#,
    '...##' => ?.,
    '.#.#.' => ?.,
    '..#..' => ?.,
    '##.#.' => ?.,
    '#.#.#' => ?#,
    '.....' => ?.,
    '#.#..' => ?.,
    '....#' => ?.,
    '.#..#' => ?.,
    '###.#' => ?#,
    '#..#.' => ?.,
    '#####' => ?.,
    '...#.' => ?#,
    '#.##.' => ?#,
    '.#.##' => ?#,
    '#..##' => ?#,
    '.##..' => ?#,
    '##.##' => ?.,
    '..###' => ?.,
    '###..' => ?.,
    '##..#' => ?#,
    '.#...' => ?#,
    '.###.' => ?#,
    '#.###' => ?.,
    '.##.#' => ?.,
    '#...#' => ?#,
    '##...' => ?.,
    '..##.' => ?.
  }

  describe "part 1" do
    test "examples" do
      init_state = Day12.pots('#..#.#..##......###...###')

      notes = %{
        '...##' => ?#,
        '..#..' => ?#,
        '.#...' => ?#,
        '.#.#.' => ?#,
        '.#.##' => ?#,
        '.##..' => ?#,
        '.####' => ?#,
        '#.#.#' => ?#,
        '#.###' => ?#,
        '##.#.' => ?#,
        '##.##' => ?#,
        '###..' => ?#,
        '###.#' => ?#,
        '####.' => ?#
      }

      assert 1..20
             |> Enum.reduce(init_state, fn _, state -> Day12.spread(state, notes) end)
             |> Day12.plant_numbers()
             |> Enum.sum() == 325
    end

    test "puzzle input" do
      init_state =
        @init_state
        |> Day12.pots()

      assert 1..20
             |> Enum.reduce(init_state, fn _, state -> Day12.spread(state, @spread_notes) end)
             |> Day12.plant_numbers()
             |> Enum.sum() == 2349
    end
  end

  describe "pots/1" do
    test "indices start from zero" do
      assert Day12.pots('.') == %{0 => ?.}
    end

    test "returns a Map with index as keys, plant status as values" do
      assert Day12.pots('.#.') == %{0 => ?., 1 => ?#, 2 => ?.}
    end
  end

  describe "spread/2" do
    test "destroys the plant if no matches (for the examples)" do
      pots = pots('..#..')
      notes = %{}

      assert Day12.spread(pots, notes) == pots('.....')
    end

    test "updates according to the notes when find a match" do
      pots = pots('..#..')
      notes = %{'..#..' => ?.}

      assert Day12.spread(pots, notes) == pots('.....')
    end

    test "updates pots to the left" do
      pots = pots('##...')
      notes = %{'...##' => ?#}

      assert Day12.spread(pots, notes) == pots('#.....', -1)
    end

    test "updates pots to the right" do
      pots = pots('...##')
      notes = %{'##...' => ?#}

      assert Day12.spread(pots, notes) == pots('.....#', 0)
    end
  end

  describe "plant_numbers/1" do
    test "returns all plant_numbers" do
      assert Day12.plant_numbers(pots('..#.#..')) == [2, 4]
    end
  end

  defp pots(input, start_from \\ 0) do
    input
    |> Enum.with_index(start_from)
    |> Enum.map(fn {pot, index} -> {index, pot} end)
    |> Map.new()
  end
end
