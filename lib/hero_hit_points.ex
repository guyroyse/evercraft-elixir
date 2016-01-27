defmodule Hero.HitPoints do

  def maximum(hero) do
    per_level(hero) * Hero.Experience.level(hero)
  end

  def current(hero) do
    maximum(hero) - hero.damage
  end

  def alive?(hero) do
    current(hero) > 0
  end

  def damage(hero, points) do
    {:ok, %{hero | damage: hero.damage + points}}
  end

  defp per_level(hero) do
    max(1, for_class(hero) + Hero.Ability.modifier(hero, :con))
  end

  defp for_class(hero) do
    case Hero.class(hero) do
      :fighter -> 10
      :monk -> 6
      _ -> 5
    end
  end

end
