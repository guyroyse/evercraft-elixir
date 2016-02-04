defmodule Hero.Ability do

  def score(hero, ability) do
    Ability.score(hero[ability])
  end

  def score(hero, ability, value) do
    case Ability.score(hero[ability], value) do
      {:ok, new_ability} -> {:ok, %{ hero | ability => new_ability } }
      {status, result} -> {status, result}
    end

  end

  def modifier(hero, ability) do
    case {Hero.race(hero), ability, Ability.modifier(hero[ability])} do
      {:orc, :str, mod} -> mod + 2
      {:orc, :int, mod} -> mod - 1
      {:orc, :wis, mod} -> mod - 1
      {:orc, :cha, mod} -> mod - 1
      {_, _, mod} -> mod
    end
  end

end
