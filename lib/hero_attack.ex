defmodule Hero.Attack do

  def modifier(hero) do
    base_modifier(hero) + Hero.Ability.modifier(hero, :str)
  end

  def damage(hero) do
    max(1, base_damage(hero))
  end

  def critical_damage(hero) do
    max(1, 2 * base_damage(hero))
  end

  defp base_modifier(hero) do
    trunc(Hero.level(hero) * modifier_per_level(hero))
  end

  defp modifier_per_level(hero) do
    case Hero.class(hero) do
      :fighter ->  1
      :no_class -> 1 / 2
    end
  end

  defp base_damage(hero) do
    1 + Hero.Ability.modifier(hero, :str)
  end

end
