defmodule Hero.Attack do

  def modifier(hero, defender) do
    Hero.Attack.Modifier.base(hero) + Hero.Attack.Modifier.ability(hero) + Hero.Attack.Modifier.special(hero, defender)
  end

  def damage(hero, defender) do
    max(1, computed_damage(hero, defender))
  end

  def critical_damage(hero, defender) do
    max(1, Hero.Attack.Damage.critical_mulitplier(hero, defender) * computed_damage(hero, defender))
  end

  defp computed_damage(hero, defender) do
    Hero.Attack.Damage.base(hero) + Hero.Attack.Damage.ability_modifier(hero) + Hero.Attack.Damage.special(hero, defender)
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

  def special(hero, defender) do
    case {Hero.class(hero), Hero.alignment(defender)} do
      {:paladin, :evil} -> 2
      {_, _} -> 0
    end
  end

  defp attack_base_modifier_per_level(hero) do
    case Hero.class(hero) do
      :fighter ->  1
      :paladin -> 1
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

  def special(hero, defender) do
    case {Hero.class(hero), Hero.alignment(defender)} do
      {:paladin, :evil} -> 2
      {_, _} -> 0
    end
  end

  def critical_mulitplier(hero, defender) do
    case {Hero.class(hero), Hero.alignment(defender)} do
      {:rogue, _} -> 3
      {:paladin, :evil} -> 3
      {_, _} -> 2
    end
  end

end
