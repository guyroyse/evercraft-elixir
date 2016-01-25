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
      _ -> 1 / 2
    end
  end

  defp ability_modifier(hero) do
    case Hero.class(hero) do
      :rogue -> Hero.Ability.modifier(hero, :dex)
      _ -> Hero.Ability.modifier(hero, :str)
    end
  end

  defp base_damage(hero) do
    1 + Hero.Ability.modifier(hero, :str)
  end

  defp critical_mulitplier(hero) do
    case Hero.class(hero) do
      :rogue -> 3
      _ -> 2
    end
  end

end
