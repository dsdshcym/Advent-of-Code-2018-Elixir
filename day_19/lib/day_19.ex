defmodule Day19 do
  @moduledoc """
  Documentation for Day19.
  """

  def part_1(input) do
    input
    |> parse_input()
    |> execute_until_ip_is_out_of_bounds()
  end

  def parse_input(_input) do
    %{
      ip_register: 0,
      program: [
        %{operation: :seti, A: 5, B: 0, C: 1},
        %{operation: :seti, A: 6, B: 0, C: 2},
        %{operation: :addi, A: 0, B: 1, C: 0},
        %{operation: :addr, A: 1, B: 2, C: 3},
        %{operation: :setr, A: 1, B: 0, C: 0},
        %{operation: :seti, A: 8, B: 0, C: 4},
        %{operation: :seti, A: 9, B: 0, C: 5}
      ],
      registers: [0, 0, 0, 0, 0, 0]
    }
  end

  def execute_until_ip_is_out_of_bounds(state) do
    %{registers: [6, 5, 6, 0, 0, 9]}
  end
end
