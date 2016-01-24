defmodule Hero.HitPoints do

  def maximum(hero) do
    max(1, 5 + Hero.Ability.modifier(hero, :con)) * Hero.level(hero)
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

end
