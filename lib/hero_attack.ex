defmodule Hero.Attack do

  def modifier(hero) do
    base_modifier(hero) + ability_modifier(hero)
  end

  def damage(hero) do
    max(1, base_damage(hero))
  end

  def critical_damage(hero) do
    max(1, critical_mulitplier(hero) * base_damage(hero))
  end

  defp base_modifier(hero) do
    trunc(Hero.Experience.level(hero) * base_modifier_per_level(hero))
  end

  defp base_modifier_per_level(hero) do
    case Hero.class(hero) do
      :fighter ->  1
      :monk -> 2 / 3
      _ -> 1 / 2
    end
  end

  defp ability_modifier(hero) do
    case Hero.class(hero) do
      :rogue -> Hero.Ability.modifier(hero, :dex)
      :monk -> Hero.Ability.modifier(hero, :str) + max(0, Hero.Ability.modifier(hero, :wis))
      _ -> Hero.Ability.modifier(hero, :str)
    end
  end

  defp base_damage(hero) do
    case Hero.class(hero) do
      :monk -> 3 + Hero.Ability.modifier(hero, :str)
      _ -> 1 + Hero.Ability.modifier(hero, :str)
    end
  end

  defp critical_mulitplier(hero) do
    case Hero.class(hero) do
      :rogue -> 3
      _ -> 2
    end
  end

end
