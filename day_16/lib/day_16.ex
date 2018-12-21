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
    input
    |> String.split("\n\n")
    |> Enum.map(&parse_sample/1)
  end

  defp parse_sample(sample_input) do
    [reg_before, instruction, reg_after] =
      sample_input
      |> String.split("\n", trim: true)

    "Before: " <> before_list_str = reg_before
    "After:  " <> after_list_str = reg_after

    %{
      before: parse_list(before_list_str),
      instruction: parse_instruction(instruction),
      after: parse_list(after_list_str)
    }
  end

  defp parse_list(list_str) do
    {"[", remain_list_str} = String.split_at(list_str, 1)
    {list_contents, "]"} = String.split_at(remain_list_str, -1)

    list_contents
    |> String.split(", ")
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_instruction(instruction) do
    [opcode, a, b, c] =
      instruction
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)

    %{opcode: opcode, A: a, B: b, C: c}
  end

  def possible_opcodes(sample) do
    [:mulr, :addi, :seti]
  end

  def possible_opcodes(sample, funcs_by_operation) do
    funcs_by_operation
    |> Enum.filter(fn
      {_operation, func} ->
        func.(sample.before, sample.instruction) == sample.after
    end)
    |> Enum.map(fn
      {operation, _func} -> operation
    end)
  end
end
