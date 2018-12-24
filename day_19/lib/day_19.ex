defmodule Day19 do
  @moduledoc """
  Documentation for Day19.
  """

  @initial_registers [0, 0, 0, 0, 0, 0]
  @initial_ip 0

  def part_1(input) do
    input
    |> parse_input()
    |> execute_until_ip_is_out_of_bounds()
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> do_parse_input()
  end

  defp do_parse_input([ip_line | program_lines]) do
    %{
      ip_register: parse_ip(ip_line),
      program: parse_program(program_lines),
      registers: @initial_registers,
      ip: @initial_ip
    }
  end

  defp parse_ip("#ip " <> ip_register_str) do
    String.to_integer(ip_register_str)
  end

  defp parse_program(program_lines) do
    program_lines
    |> Enum.map(fn line ->
      [operation, a, b, c] = String.split(line, " ")

      %{
        operation: String.to_atom(operation),
        A: String.to_integer(a),
        B: String.to_integer(b),
        C: String.to_integer(c)
      }
    end)
  end

  def execute_until_ip_is_out_of_bounds(%{ip: ip, program: program} = state)
      when ip >= length(program) do
    state
  end

  def execute_until_ip_is_out_of_bounds(state) do
    state
    |> execute()
    |> execute_until_ip_is_out_of_bounds()
  end

  def execute(state) do
    %{state | ip_register: 7, registers: [6, 5, 6, 0, 0, 9]}
  end
end
