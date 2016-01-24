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
    Ability.modifier(hero[ability])
  end

end
