defmodule FuelGrid do
  defmodule Grid do
    defstruct [:power_levels, :x_range, :y_range]
  end

  def generate(serial_number, x_range, y_range) do
    power_levels =
      for x <- x_range,
          y <- y_range,
          point = {x, y},
          do: {point, calc(point, serial_number)},
          into: %{}

    %Grid{
      power_levels: power_levels,
      x_range: x_range,
      y_range: y_range
    }
  end

  def calc({x, y}, serial_number) do
    rack_id = x + 10
    hundreds_digit((rack_id * y + serial_number) * rack_id) - 5
  end

  def hundreds_digit(number) when 0 <= number and number < 100, do: 0
  def hundreds_digit(number) when number >= 100, do: number |> div(100) |> rem(10)

  def largest_3x3_square(grid) do
    min_x..max_x = grid.x_range
    min_y..max_y = grid.y_range

    for x <- min_x..(max_x - 2), y <- min_y..(max_y - 2) do
      {x, y}
    end
    |> Enum.max_by(&sum_3x3_square(grid.power_levels, &1))
  end

  defp sum_3x3_square(power_levels, {x, y}) do
    for dx <- 0..2, dy <- 0..2 do
      power_levels[{x + dx, y + dy}]
    end
    |> Enum.sum()
  end
end

ExUnit.start()

defmodule FuelGridTest do
  use ExUnit.Case

  test "part 1" do
    grid_serial_number = 8561

    assert grid_serial_number
           |> FuelGrid.generate(1..300, 1..300)
           |> FuelGrid.largest_3x3_square() == {21, 37}
  end

  describe "calc/2" do
    test "examples" do
      assert FuelGrid.calc({3, 5}, 8) == 4
      assert FuelGrid.calc({122, 79}, 57) == -5
      assert FuelGrid.calc({217, 196}, 39) == 0
      assert FuelGrid.calc({101, 153}, 71) == 4
    end
  end

  describe "hundreds_digit/1" do
    test "returns hundreds digit of input if it has one" do
      assert FuelGrid.hundreds_digit(900) == 9
      assert FuelGrid.hundreds_digit(1100) == 1
    end

    test "returns 0 if input does not have hundreds digit" do
      assert FuelGrid.hundreds_digit(99) == 0
    end
  end

  describe "largest_3x3_square/1" do
    test "examples" do
      grid = %FuelGrid.Grid{
        power_levels: %{
          {1, 1} => -2,
          {1, 2} => -4,
          {1, 3} => 4,
          {1, 4} => 1,
          {1, 5} => -1,
          {2, 1} => -4,
          {2, 2} => 4,
          {2, 3} => 3,
          {2, 4} => 1,
          {2, 5} => 0,
          {3, 1} => 4,
          {3, 2} => 4,
          {3, 3} => 3,
          {3, 4} => 2,
          {3, 5} => 2,
          {4, 1} => 4,
          {4, 2} => 4,
          {4, 3} => 4,
          {4, 4} => 4,
          {4, 5} => -5,
          {5, 1} => 4,
          {5, 2} => -5,
          {5, 3} => -4,
          {5, 4} => -3,
          {5, 5} => -2
        },
        x_range: 1..5,
        y_range: 1..5
      }

      assert FuelGrid.largest_3x3_square(grid) == {2, 2}
    end
  end
end
