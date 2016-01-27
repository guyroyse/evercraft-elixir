defmodule Hero.Attack do

  def modifier(hero) do
    Hero.Attack.Modifier.base(hero) + Hero.Attack.Modifier.ability(hero)
  end

  def damage(hero) do
    max(1, base_damage_plus_ability_modifier(hero))
  end

  def critical_damage(hero) do
    max(1, Hero.Attack.Damage.critical_mulitplier(hero) * base_damage_plus_ability_modifier(hero))
  end

  defp base_damage_plus_ability_modifier(hero) do
    Hero.Attack.Damage.base(hero) + Hero.Attack.Damage.ability_modifier(hero)
  end

end

defmodule Hero.Attack.Modifier do

  def base(hero) do
    trunc(Hero.Experience.level(hero) * attack_base_modifier_per_level(hero))
  end

  def ability(hero) do
    case Hero.class(hero) do
      :rogue -> Hero.Ability.modifier(hero, :dex)
      :monk -> Hero.Ability.modifier(hero, :str) + max(0, Hero.Ability.modifier(hero, :wis))
      _ -> Hero.Ability.modifier(hero, :str)
    end
  end

  defp attack_base_modifier_per_level(hero) do
    case Hero.class(hero) do
      :fighter ->  1
      :monk -> 2 / 3
      _ -> 1 / 2
    end
  end

end

defmodule Hero.Attack.Damage do

  def base(hero) do
    case Hero.class(hero) do
      :monk -> 3
      _ -> 1
    end
  end

  def ability_modifier(hero) do
    Hero.Ability.modifier(hero, :str)
  end

  def critical_mulitplier(hero) do
    case Hero.class(hero) do
      :rogue -> 3
      _ -> 2
    end
  end

end
