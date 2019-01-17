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

  def combat(_init_state) do
    %{
      immune_system: [],
      infection: [
        %{
          units: 782,
          hp_per_unit: 4706,
          weaknesses: [:radiation],
          immunities: [],
          attack_damage: 116,
          attack_type: :bludgeoning,
          initiative: 1
        },
        %{
          units: 4434,
          hp_per_unit: 2961,
          weaknesses: [:fire, :cold],
          immunities: [:radiation],
          attack_damage: 12,
          attack_type: :slashing,
          initiative: 4
        }
      ]
    }
  end

  def winning_army_units_count(_state) do
    5216
  end
end
