defmodule Day24 do
  alias Day24.Group

  def part_1(input) do
    input
    |> parse()
    |> combat()
    |> winning_army_units_count()
  end

  def parse(input) do
    ["Immune System:\n" <> immune_system_input, "Infection:\n" <> infection_input] =
      input
      |> String.split("\n\n")

    Map.new(
      parse_groups(immune_system_input, :immune_system) ++
        parse_groups(infection_input, :infection)
    )
  end

  defp parse_groups(lines, army) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_group(&1, army))
  end

  def parse_group(line, army) do
    %{
      "units" => units,
      "hp_per_unit" => hp_per_unit,
      "weaknesses_or_immunities" => weaknesses_or_immunities,
      "attack_damage" => attack_damage,
      "attack_type" => attack_type,
      "initiative" => initiative
    } =
      Regex.named_captures(
        ~r/^(?<units>[0-9]+) units each with (?<hp_per_unit>[0-9]+) hit points (?<weaknesses_or_immunities>(\(.*\) )?)with an attack that does (?<attack_damage>[0-9]+) (?<attack_type>\w+) damage at initiative (?<initiative>[0-9]+)/,
        line
      )

    %{weaknesses: weaknesses, immunities: immunities} =
      parse_weaknesses_and_immunities(weaknesses_or_immunities)

    {
      String.to_integer(initiative),
      %{
        units: String.to_integer(units),
        hp_per_unit: String.to_integer(hp_per_unit),
        weaknesses: weaknesses,
        immunities: immunities,
        attack_damage: String.to_integer(attack_damage),
        attack_type: String.to_atom(attack_type),
        initiative: String.to_integer(initiative),
        army: army
      }
    }
  end

  defp parse_weaknesses_and_immunities(""), do: %{weaknesses: [], immunities: []}

  defp parse_weaknesses_and_immunities(weaknesses_or_immunities) do
    Map.merge(
      parse_weaknesses(weaknesses_or_immunities),
      parse_immunities(weaknesses_or_immunities)
    )
  end

  defp parse_weaknesses(weaknesses_or_immunities) do
    case Regex.run(~r/weak to ([^;)]*)/, weaknesses_or_immunities) do
      [_, weaknesses | _] ->
        %{
          weaknesses:
            weaknesses
            |> String.split(", ")
            |> Enum.map(&String.to_atom/1)
        }

      nil ->
        %{weaknesses: []}
    end
  end

  defp parse_immunities(weaknesses_or_immunities) do
    case Regex.run(~r/immune to ([^;)]*)/, weaknesses_or_immunities) do
      [_, immunities | _] ->
        %{
          immunities:
            immunities
            |> String.split(", ")
            |> Enum.map(&String.to_atom/1)
        }

      nil ->
        %{immunities: []}
    end
  end

  def combat(init_state) do
    init_state
    |> create_groups
    |> fight_until_one_army_left
  end

  defp create_groups(init_groups_by_initiative) do
    init_groups_by_initiative
    |> Enum.map(fn {initiative, init_group} -> {initiative, Group.create(init_group)} end)
    |> Map.new()
  end

  def fight_until_one_army_left(state) do
    if only_one_army_left?(state) do
      state
    else
      defenders_by_attacker = state |> target_selection_phase
      updated_state = attacking_phase(state, defenders_by_attacker)
      fight_until_one_army_left(updated_state)
    end
  end

  defp only_one_army_left?(state) do
    1 ==
      state
      |> groups()
      |> Enum.map(&Group.army/1)
      |> Enum.uniq()
      |> Enum.count()
  end

  def target_selection_phase(state) do
    state
    |> groups()
    |> sort_by_descending_order_of_effective_power_and_initiative()
    |> Enum.reduce(%{}, fn attacker, defenders_by_attacker ->
      state
      |> groups()
      |> enemy_groups_of(attacker)
      |> not_chosen_as_target_yet(defenders_by_attacker)
      |> Enum.group_by(&Group.full_damage_if_attack(attacker, &1))
      |> Enum.reject(fn {full_damage, _} -> full_damage == 0 end)
      |> Enum.max_by(
        fn {full_damage, _potential_targets} -> full_damage end,
        fn -> {nil, []} end
      )
      |> case do
        {_, []} ->
          defenders_by_attacker

        {_, potential_targets} ->
          [target | _] =
            potential_targets
            |> sort_by_descending_order_of_effective_power_and_initiative()

          Map.put(defenders_by_attacker, attacker, target)
      end
    end)
  end

  def attacking_phase(state, defenders_by_attacker) do
    defenders_by_attacker
    |> Enum.sort_by(
      fn {attacker, _defender} -> Group.initiative(attacker) end,
      &>/2
    )
    |> Enum.reduce(state, fn {attacker, defender}, state ->
      Group.attack(attacker, defender)

      if Group.units(defender) == 0 do
        Map.delete(state, Group.initiative(defender))
      else
        state
      end
    end)
  end

  defp enemy_groups_of(groups, group) do
    groups
    |> Enum.filter(&enemy?(Group.army(&1), Group.army(group)))
  end

  defp not_chosen_as_target_yet(groups, defenders_by_attacker) do
    defenders = Map.values(defenders_by_attacker)

    groups
    |> Enum.reject(&(&1 in defenders))
  end

  defp enemy?(:immune_system, :infection), do: true
  defp enemy?(:infection, :immune_system), do: true
  defp enemy?(_, _), do: false

  defp groups(state) do
    Map.values(state)
  end

  defp sort_by_descending_order_of_effective_power_and_initiative(groups) do
    groups
    |> Enum.sort_by(&{Group.effective_power(&1), Group.initiative(&1)}, &>/2)
  end

  def winning_army_units_count(state) do
    state
    |> groups()
    |> Enum.map(&Group.units/1)
    |> Enum.sum()
  end
end
