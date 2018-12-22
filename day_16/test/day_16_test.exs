defmodule Day16Test do
  use ExUnit.Case
  doctest Day16

  describe "part 1" do
    test "example" do
      input = """
      Before: [3, 2, 1, 1]
      9 2 1 2
      After:  [3, 2, 2, 1]
      """

      assert input
             |> Day16.possible_opcodes_for_every_sample()
             |> Enum.count(&(length(&1) >= 3)) == 1
    end

    test "puzzle input" do
      input = File.read!("./test/fixtures/samples.txt")

      assert input
             |> Day16.possible_opcodes_for_every_sample()
             |> Enum.count(&(length(&1) >= 3)) == 521
    end
  end

  describe "possible_operations_by_opcodes/1" do
    test "no possible operations" do
      input = """
      Before: [1, 2, 3, 4]
      0 0 0 0
      After:  [0, 0, 0, 0]
      """

      assert %{0 => []} =
               input
               |> Day16.possible_operations_by_opcodes()
    end

    test "one possible operation" do
      input = """
      Before: [1, 2, 3, 4]
      0 0 0 0
      After:  [2, 2, 3, 4]
      """

      assert %{0 => [:addr]} =
               input
               |> Day16.possible_operations_by_opcodes()
    end

    test "multiple possible operations" do
      input = """
      Before: [1, 2, 3, 4]
      0 2 3 0
      After:  [7, 2, 3, 4]
      """

      assert %{0 => [:addr, :borr]} =
               input
               |> Day16.possible_operations_by_opcodes()
    end

    test "returns unique results" do
      input = """
      Before: [1, 2, 3, 4]
      0 0 0 0
      After:  [2, 2, 3, 4]

      Before: [1, 2, 3, 4]
      0 0 0 0
      After:  [2, 2, 3, 4]
      """

      assert %{0 => [:addr]} =
               input
               |> Day16.possible_operations_by_opcodes()
    end

    test "merges results from multiple samples" do
      input = """
      Before: [1, 2, 3, 4]
      0 0 0 0
      After:  [2, 2, 3, 4]

      Before: [1, 2, 3, 4]
      0 3 2 0
      After:  [1, 2, 3, 4]
      """

      assert %{0 => [:addr, :eqir, :gtri, :gtrr]} =
               input
               |> Day16.possible_operations_by_opcodes()
    end

    test "groups results by opcode numbers" do
      input = """
      Before: [1, 2, 3, 4]
      0 0 0 0
      After:  [2, 2, 3, 4]

      Before: [1, 2, 3, 4]
      1 3 2 0
      After:  [1, 2, 3, 4]
      """

      assert %{0 => [:addr], 1 => [:eqir, :gtri, :gtrr]} =
               input
               |> Day16.possible_operations_by_opcodes()
    end
  end

  describe "decide_operations/1" do
    test "returns empty map for empty input" do
      assert %{} = Day16.decide_operations(%{})
    end

    test "decides operation if an opcode only has one possibility" do
      assert %{0 => :addr} = Day16.decide_operations(%{0 => [:addr]})
    end

    test "decides operation for opcode that has multiple possibilities" do
      assert %{1 => :mulr} = Day16.decide_operations(%{0 => [:addr], 1 => [:addr, :mulr]})
    end
  end

  describe "parse_samples/1" do
    test "parses before list" do
      input = """
      Before: [1, 2, 3, 4]
      0 0 0 0
      After:  [0, 0, 0, 0]
      """

      assert [%{before: [1, 2, 3, 4]}] = Day16.parse_samples(input)
    end

    test "parses instruction map" do
      input = """
      Before: [0, 0, 0, 0]
      15 1 3 2
      After:  [0, 0, 0, 0]
      """

      assert [%{instruction: %{opcode: 15, A: 1, B: 3, C: 2}}] = Day16.parse_samples(input)
    end

    test "parses after list" do
      input = """
      Before: [0, 0, 0, 0]
      0 0 0 0
      After:  [923, 82, 789, 654]
      """

      assert [%{after: [923, 82, 789, 654]}] = Day16.parse_samples(input)
    end

    test "parses multiple samples separated by an empty line" do
      input = """
      Before: [3, 2, 2, 3]
      3 1 1 0
      After:  [1, 2, 2, 3]

      Before: [0, 1, 2, 3]
      5 1 0 0
      After:  [1, 1, 2, 3]
      """

      assert [
               %{
                 before: [3, 2, 2, 3],
                 instruction: %{opcode: 3, A: 1, B: 1, C: 0},
                 after: [1, 2, 2, 3]
               },
               %{
                 before: [0, 1, 2, 3],
                 instruction: %{opcode: 5, A: 1, B: 0, C: 0},
                 after: [1, 1, 2, 3]
               }
             ] = Day16.parse_samples(input)
    end
  end

  describe "possible_opcodes/2" do
    test "returns operation that returns the same results as after when given before and instruction" do
      funcs_by_operation = %{operation: fn :before_regs, %{A: 1, B: 2, C: 3} -> :results end}

      assert :operation in Day16.possible_opcodes(
               %{before: :before_regs, instruction: %{A: 1, B: 2, C: 3}, after: :results},
               funcs_by_operation
             )
    end

    test "does not return operation that returns different results than after" do
      funcs_by_operation = %{
        operation: fn :before_regs, %{A: 1, B: 2, C: 3} -> :another_results end
      }

      assert :operation not in Day16.possible_opcodes(
               %{before: :before_regs, instruction: %{A: 1, B: 2, C: 3}, after: :results},
               funcs_by_operation
             )
    end
  end

  describe "default_funcs_by_operation/0" do
    test ":addr stores into register C the result of adding register A and register B" do
      assert Day16.default_funcs_by_operation()[:addr].([1, 2, 0, 0], %{A: 0, B: 1, C: 2})
             |> Enum.at(2) == 3
    end

    test ":addi stores into register C the result of adding register A and value B" do
      assert Day16.default_funcs_by_operation()[:addi].([1, 2, 0, 0], %{A: 0, B: 1, C: 2})
             |> Enum.at(2) == 2
    end

    test ":mulr stores into register C the result of multiplying register A and register B" do
      assert Day16.default_funcs_by_operation()[:mulr].([3, 4, 0, 0], %{A: 0, B: 1, C: 2})
             |> Enum.at(2) == 12
    end

    test ":muli stores into register C the result of multiplying register A and value B." do
      assert Day16.default_funcs_by_operation()[:muli].([3, 4, 0, 0], %{A: 0, B: 1, C: 2})
             |> Enum.at(2) == 3
    end

    test ":banr stores into register C the result of the bitwise AND of register A and register B." do
      assert Day16.default_funcs_by_operation()[:banr].([0, 0, 4, 6], %{A: 3, B: 2, C: 1})
             |> Enum.at(1) == 4
    end

    test ":bani stores into register C the result of the bitwise AND of register A and value B." do
      assert Day16.default_funcs_by_operation()[:bani].([0, 0, 4, 6], %{A: 3, B: 2, C: 1})
             |> Enum.at(1) == 2
    end

    test ":borr stores into register C the result of the bitwise OR of register A and register B." do
      assert Day16.default_funcs_by_operation()[:borr].([0, 0, 2, 4], %{A: 3, B: 2, C: 1})
             |> Enum.at(1) == 6
    end

    test ":bori stores into register C the result of the bitwise OR of register A and value B." do
      assert Day16.default_funcs_by_operation()[:bori].([0, 0, 2, 9], %{A: 3, B: 2, C: 1})
             |> Enum.at(1) == 11
    end

    test ":setr copies the contents of register A into register C. (Input B is ignored.)" do
      assert Day16.default_funcs_by_operation()[:setr].([0, 0, 2, 9], %{A: 3, B: nil, C: 0})
             |> Enum.at(0) == 9
    end

    test ":seti stores value A into register C. (Input B is ignored.)" do
      assert Day16.default_funcs_by_operation()[:seti].([0, 0, 2, 9], %{A: 3, B: nil, C: 0})
             |> Enum.at(0) == 3
    end

    test ":gtir sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0." do
      assert Day16.default_funcs_by_operation()[:gtir].([0, 0, 2, 9], %{A: 3, B: 2, C: 0})
             |> Enum.at(0) == 1

      assert Day16.default_funcs_by_operation()[:gtir].([1, 0, 2, 9], %{A: 3, B: 3, C: 0})
             |> Enum.at(0) == 0
    end

    test ":gtri sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0." do
      assert Day16.default_funcs_by_operation()[:gtri].([0, 0, 2, 3], %{A: 3, B: 2, C: 0})
             |> Enum.at(0) == 1

      assert Day16.default_funcs_by_operation()[:gtri].([1, 0, 2, 3], %{A: 3, B: 3, C: 0})
             |> Enum.at(0) == 0
    end

    test ":gtrr sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0." do
      assert Day16.default_funcs_by_operation()[:gtrr].([0, 0, 3, 2], %{A: 2, B: 3, C: 0})
             |> Enum.at(0) == 1

      assert Day16.default_funcs_by_operation()[:gtrr].([1, 0, 2, 3], %{A: 2, B: 3, C: 0})
             |> Enum.at(0) == 0
    end

    test ":eqir sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0." do
      assert Day16.default_funcs_by_operation()[:eqir].([0, 0, 3, 9], %{A: 3, B: 2, C: 0})
             |> Enum.at(0) == 1

      assert Day16.default_funcs_by_operation()[:eqir].([1, 0, 2, 9], %{A: 10, B: 3, C: 0})
             |> Enum.at(0) == 0
    end

    test ":eqri sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0." do
      assert Day16.default_funcs_by_operation()[:eqri].([0, 0, 7, 2], %{A: 3, B: 2, C: 0})
             |> Enum.at(0) == 1

      assert Day16.default_funcs_by_operation()[:eqri].([1, 0, 2, 9], %{A: 3, B: 3, C: 0})
             |> Enum.at(0) == 0
    end

    test ":eqrr sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0." do
      assert Day16.default_funcs_by_operation()[:eqrr].([0, 0, 2, 2], %{A: 2, B: 3, C: 0})
             |> Enum.at(0) == 1

      assert Day16.default_funcs_by_operation()[:eqrr].([1, 0, 2, 9], %{A: 2, B: 3, C: 0})
             |> Enum.at(0) == 0
    end
  end
end
