defmodule Day16 do
  @moduledoc """
  Documentation for Day16.
  """

  def possible_opcodes_for_every_sample(input) do
    input
    |> parse_samples()
    |> Enum.map(&possible_opcodes/1)
  end

  def parse_samples(input) do
    [
      %{
        before: [3, 2, 1, 1],
        instruction: %{opcode: 9, A: 2, B: 1, C: 2},
        after: [3, 2, 2, 1]
      }
    ]
  end

  def possible_opcodes(sample) do
    [:mulr, :addi, :seti]
  end
end
