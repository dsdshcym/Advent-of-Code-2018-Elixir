defmodule Day24 do
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

    %{
      immune_system: parse_groups(immune_system_input),
      infection: parse_groups(infection_input)
    }
  end

  defp parse_groups(lines) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_group/1)
  end

  def parse_group(line) do
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

    %{
      units: String.to_integer(units),
      hp_per_unit: String.to_integer(hp_per_unit),
      weaknesses: weaknesses,
      immunities: immunities,
      attack_damage: String.to_integer(attack_damage),
      attack_type: String.to_atom(attack_type),
      initiative: String.to_integer(initiative)
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
    init_state =
      Enum.map(init_state.immune_system, &Map.put(&1, :army, :immune_system)) ++
        Enum.map(init_state.infection, &Map.put(&1, :army, :infection))

    fight_until_one_army_left(init_state)
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
      |> Enum.map(& &1.army)
      |> Enum.uniq()
      |> Enum.count()
  end

  def target_selection_phase(state) do
    state
    |> sort_by_descending_order_of_effective_power_and_initiative()
    |> Enum.reduce(%{}, fn attacker, defenders_by_attacker ->
      state
      |> enemy_groups_of(attacker)
      |> not_chosen_as_target_yet(defenders_by_attacker)
      |> Enum.group_by(&full_damage(attacker, &1))
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

          Map.put(defenders_by_attacker, attacker.initiative, target.initiative)
      end
    end)
  end

  def attacking_phase(state, defenders_by_attacker) do
    defenders_by_attacker
    |> Enum.sort_by(
      fn {attacker_initiative, _defender_initiative} -> attacker_initiative end,
      &>/2
    )
    |> Enum.reduce(state, fn {attacker_initiative, defender_initiative}, state ->
      attack(state, attacker_initiative, defender_initiative)
    end)
  end

  defp attack(state, attacker_initiative, defender_initiative) do
    with attacker when not is_nil(attacker) <- find_by_initiative(state, attacker_initiative),
         defender when not is_nil(defender) <- find_by_initiative(state, defender_initiative) do
      update_group(state, defender_initiative, attack(attacker, defender))
    else
      nil -> state
    end
  end

  defp attack(attacker, defender) do
    full_damage = full_damage(attacker, defender)
    killed_units = Enum.min([defender.units, div(full_damage, defender.hp_per_unit)])
    remained_units = defender.units - killed_units
    %{defender | units: remained_units}
  end

  defp update_group(state, group_initiative, %{units: 0}) do
    old_group = find_by_initiative(state, group_initiative)

    state
    |> List.delete(old_group)
  end

  defp update_group(state, group_initiative, new_group) do
    old_group = find_by_initiative(state, group_initiative)

    [
      new_group
      | state
        |> List.delete(old_group)
    ]
  end

  defp find_by_initiative(state, initiative) do
    state
    |> Enum.find(&(&1.initiative == initiative))
  end

  defp enemy_groups_of(groups, group) do
    groups
    |> Enum.filter(&enemy?(&1.army, group.army))
  end

  defp not_chosen_as_target_yet(groups, defenders_by_attacker) do
    defender_initiatives = Map.values(defenders_by_attacker)

    groups
    |> Enum.reject(&(&1.initiative in defender_initiatives))
  end

  defp full_damage(attacker, defender) do
    cond do
      immune_to?(defender, attacker) -> 0
      weak_to?(defender, attacker) -> effective_power(attacker) * 2
      true -> effective_power(attacker)
    end
  end

  defp immune_to?(defender, attacker) do
    attacker.attack_type in defender.immunities
  end

  defp weak_to?(defender, attacker) do
    attacker.attack_type in defender.weaknesses
  end

  defp enemy?(:immune_system, :infection), do: true
  defp enemy?(:infection, :immune_system), do: true
  defp enemy?(_, _), do: false

  defp sort_by_descending_order_of_effective_power_and_initiative(groups) do
    groups
    |> Enum.sort_by(&{effective_power(&1), &1.initiative}, &>/2)
  end

  defp effective_power(group) do
    group.units * group.attack_damage
  end

  def winning_army_units_count(state) do
    state
    |> Enum.map(& &1.units)
    |> Enum.sum()
  end
end
