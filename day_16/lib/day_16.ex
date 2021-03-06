defmodule Day16 do
  @moduledoc """
  Documentation for Day16.
  """

  def possible_opcodes_for_every_sample(input) do
    input
    |> parse_samples()
    |> Enum.map(&possible_opcodes/1)
  end

  def possible_operations_by_opcodes(input) do
    input
    |> parse_samples()
    |> Enum.map(&{&1.instruction[:opcode], possible_opcodes(&1)})
    |> Enum.group_by(
      fn {opcode, _} -> opcode end,
      fn {_, possible_operations} -> possible_operations end
    )
    |> Enum.map(fn {opcode, possible_operations_groups} ->
      {
        opcode,
        possible_operations_groups |> List.flatten() |> Enum.uniq()
      }
    end)
    |> Map.new()
  end

  def decide_operations(possible_operations_by_opcodes) do
    possible_operations_by_opcodes
    |> Map.to_list()
    |> decide_operations(%{})
  end

  defp decide_operations([], operations_by_opcodes) do
    operations_by_opcodes
  end

  defp decide_operations(possible_operations_by_opcodes, operations_by_opcodes) do
    {decided_opcode, [operation]} =
      possible_operations_by_opcodes
      |> Enum.find(fn {opcode, possible_operations} -> length(possible_operations) == 1 end)

    possible_operations_by_opcodes
    |> Enum.reject(fn
      {opcode, _} -> opcode == decided_opcode
    end)
    |> Enum.map(fn
      {opcode, possible_operations} ->
        {
          opcode,
          possible_operations |> Enum.reject(&(&1 == operation))
        }
    end)
    |> decide_operations(Map.put(operations_by_opcodes, decided_opcode, operation))
  end

  def execute(instructions, operations_by_opcodes) do
    instructions
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
    |> Enum.reduce([0, 0, 0, 0], fn instruction, registers ->
      operation = operations_by_opcodes[instruction.opcode]

      default_funcs_by_operation()[operation].(registers, instruction)
    end)
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

  def possible_opcodes(sample, funcs_by_operation \\ default_funcs_by_operation()) do
    funcs_by_operation
    |> Enum.filter(fn
      {_operation, func} ->
        func.(sample.before, sample.instruction) == sample.after
    end)
    |> Enum.map(fn
      {operation, _func} -> operation
    end)
  end

  import Bitwise

  def default_funcs_by_operation do
    %{
      addr: fn before, instruction ->
        reg_a = Enum.at(before, instruction[:A])
        reg_b = Enum.at(before, instruction[:B])
        List.replace_at(before, instruction[:C], reg_a + reg_b)
      end,
      addi: fn before, instruction ->
        reg_a = Enum.at(before, instruction[:A])
        value_b = instruction[:B]
        List.replace_at(before, instruction[:C], reg_a + value_b)
      end,
      mulr: fn before, instruction ->
        reg_a = Enum.at(before, instruction[:A])
        reg_b = Enum.at(before, instruction[:B])
        List.replace_at(before, instruction[:C], reg_a * reg_b)
      end,
      muli: fn before, instruction ->
        reg_a = Enum.at(before, instruction[:A])
        value_b = instruction[:B]
        List.replace_at(before, instruction[:C], reg_a * value_b)
      end,
      banr: fn before, instruction ->
        reg_a = Enum.at(before, instruction[:A])
        reg_b = Enum.at(before, instruction[:B])
        List.replace_at(before, instruction[:C], band(reg_a, reg_b))
      end,
      bani: fn before, instruction ->
        reg_a = Enum.at(before, instruction[:A])
        value_b = instruction[:B]
        List.replace_at(before, instruction[:C], band(reg_a, value_b))
      end,
      borr: fn before, instruction ->
        reg_a = Enum.at(before, instruction[:A])
        reg_b = Enum.at(before, instruction[:B])
        List.replace_at(before, instruction[:C], bor(reg_a, reg_b))
      end,
      bori: fn before, instruction ->
        reg_a = Enum.at(before, instruction[:A])
        value_b = instruction[:B]
        List.replace_at(before, instruction[:C], bor(reg_a, value_b))
      end,
      setr: fn before, instruction ->
        reg_a = Enum.at(before, instruction[:A])
        List.replace_at(before, instruction[:C], reg_a)
      end,
      seti: fn before, instruction ->
        value_a = instruction[:A]
        List.replace_at(before, instruction[:C], value_a)
      end,
      gtir: fn before, instruction ->
        value_a = instruction[:A]
        reg_b = Enum.at(before, instruction[:B])

        if value_a > reg_b do
          List.replace_at(before, instruction[:C], 1)
        else
          List.replace_at(before, instruction[:C], 0)
        end
      end,
      gtri: fn before, instruction ->
        reg_a = Enum.at(before, instruction[:A])
        value_b = instruction[:B]

        if reg_a > value_b do
          List.replace_at(before, instruction[:C], 1)
        else
          List.replace_at(before, instruction[:C], 0)
        end
      end,
      gtrr: fn before, instruction ->
        reg_a = Enum.at(before, instruction[:A])
        reg_b = Enum.at(before, instruction[:B])

        if reg_a > reg_b do
          List.replace_at(before, instruction[:C], 1)
        else
          List.replace_at(before, instruction[:C], 0)
        end
      end,
      eqir: fn before, instruction ->
        value_a = instruction[:A]
        reg_b = Enum.at(before, instruction[:B])

        if value_a == reg_b do
          List.replace_at(before, instruction[:C], 1)
        else
          List.replace_at(before, instruction[:C], 0)
        end
      end,
      eqri: fn before, instruction ->
        reg_a = Enum.at(before, instruction[:A])
        value_b = instruction[:B]

        if reg_a == value_b do
          List.replace_at(before, instruction[:C], 1)
        else
          List.replace_at(before, instruction[:C], 0)
        end
      end,
      eqrr: fn before, instruction ->
        reg_a = Enum.at(before, instruction[:A])
        reg_b = Enum.at(before, instruction[:B])

        if reg_a == reg_b do
          List.replace_at(before, instruction[:C], 1)
        else
          List.replace_at(before, instruction[:C], 0)
        end
      end
    }
  end
end
