defmodule HeroAttackTest do
  use ExUnit.Case

  setup do
    {:ok, subject: Hero.create() }
  end

  ## attack modifier
  test "it has default attack modifier of 0", context do
    assert Hero.Attack.modifier(context[:subject]) == 0
  end
  test "it add +1 to attack modifier at even levels", context do
    Enum.each([{1000, +1}, {2000, +1}, {3000, +2}, {4000, +2}], fn({xp, modifier}) ->
      {:ok, hero} = Hero.add_experience(context[:subject], xp)
      assert Hero.Attack.modifier(hero) == modifier
    end)
  end
  test "it adds str modifier to attack modifier", context do
    {:ok, hero} = Hero.Ability.score(context[:subject], :str, 15)
    assert Hero.Attack.modifier(hero) == +2
  end

  ## attack modifier - when a fighter
  test "when a fighter it has default attack modifier of +1", context do
    {:ok, hero} = Hero.class(context[:subject], :fighter)
    assert Hero.Attack.modifier(hero) == +1
  end
  test "when a fighter it add +1 to attack modifier at every level", context do
    Enum.each([{1000, +2}, {2000, +3}, {3000, +4}, {4000, +5}], fn({xp, modifier}) ->
      {:ok, hero} = Hero.class(context[:subject], :fighter)
      {:ok, hero} = Hero.add_experience(hero, xp)
      assert Hero.Attack.modifier(hero) == modifier
    end)
  end

  ## attack damage
  test "it has default attack damage of 1", context do
    assert Hero.Attack.damage(context[:subject]) == 1
  end
  test "it adds str modifier to attack damage", context do
    {:ok, hero} = Hero.Ability.score(context[:subject], :str, 15)
    assert Hero.Attack.damage(hero) == 3
  end
  test "it cannot do less than 1 point of damage regardless of str modifier", context do
    {:ok, hero} = Hero.Ability.score(context[:subject], :str, 6)
    assert Hero.Attack.damage(hero) == 1
  end

  ## critical damage
  test "it has default critical damage of 2", context do
    assert Hero.Attack.critical_damage(context[:subject]) == 2
  end
  test "it adds double the str modifier to attack damage", context do
    {:ok, hero} = Hero.Ability.score(context[:subject], :str, 15)
    assert Hero.Attack.critical_damage(hero) == 6
  end
  test "it cannot do less than 1 point of damage on a crit regardless of str modifier", context do
    {:ok, hero} = Hero.Ability.score(context[:subject], :str, 6)
    assert Hero.Attack.critical_damage(hero) == 1
  end

end
