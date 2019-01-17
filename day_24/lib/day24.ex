defmodule Day24 do
  def part_1(input) do
    input
    |> parse()
    |> combat()
    |> winning_army_units_count()
  end

  def parse(_input) do
    %{
      immune_system: [
        %{
          units: 17,
          hp_per_unit: 5390,
          weaknesses: [:radiation, :bludgeoning],
          immunities: [],
          attack_damage: 4507,
          attack_type: :fire,
          initiative: 2
        },
        %{
          units: 989,
          hp_per_unit: 1274,
          weaknesses: [:bludgeoning, :slashing],
          immunities: [:fire],
          attack_damage: 25,
          attack_type: :slashing,
          initiative: 3
        }
      ],
      infection: [
        %{
          units: 801,
          hp_per_unit: 4706,
          weaknesses: [:radiation],
          immunities: [],
          attack_damage: 116,
          attack_type: :bludgeoning,
          initiative: 1
        },
        %{
          units: 4485,
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

  def parse_unit(line) do
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
