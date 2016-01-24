defmodule Hero.Attack do

  def modifier(hero) do
    div(Hero.level(hero), 2) + Hero.Ability.modifier(hero, :str)
  end

  def damage(hero) do
    max(1, base_damage(hero))
  end

  def critical_damage(hero) do
    max(1, 2 * base_damage(hero))
  end

  defp base_damage(hero) do
    1 + Hero.Ability.modifier(hero, :str)
  end

end
