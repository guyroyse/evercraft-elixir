defmodule HeroAttackTest do
  use ExUnit.Case

  setup do
    {:ok, subject: Hero.create(), defender: Hero.create() }
  end

  ## attack modifier
  test "it has default attack modifier of 0", context do
    assert Hero.Attack.modifier(context[:subject], context[:defender]) == 0
  end
  test "it add +1 to attack modifier at even levels", context do
    Enum.each([{1000, +1}, {2000, +1}, {3000, +2}, {4000, +2}], fn({xp, modifier}) ->
      {:ok, hero} = Hero.Experience.add(context[:subject], xp)
      assert Hero.Attack.modifier(hero, context[:defender]) == modifier
    end)
  end
  test "it adds str modifier to attack modifier", context do
    {:ok, hero} = Hero.Ability.score(context[:subject], :str, 15)
    assert Hero.Attack.modifier(hero, context[:defender]) == +2
  end

  ## attack modifier - when a fighter
  test "when a fighter it has default attack modifier of +1", context do
    {:ok, hero} = Hero.class(context[:subject], :fighter)
    assert Hero.Attack.modifier(hero, context[:defender]) == +1
  end
  test "when a fighter it add +1 to attack modifier at every level", context do
    Enum.each([{1000, +2}, {2000, +3}, {3000, +4}, {4000, +5}], fn({xp, modifier}) ->
      {:ok, hero} = Hero.class(context[:subject], :fighter)
      {:ok, hero} = Hero.Experience.add(hero, xp)
      assert Hero.Attack.modifier(hero, context[:defender]) == modifier
    end)
  end

  ## attack modifier - when a rogue
  test "when a rogue it adds dex modifier to attack modifier", context do
    {:ok, hero} = Hero.class(context[:subject], :rogue)
    {:ok, hero} = Hero.Ability.score(hero, :dex, 15)
    assert Hero.Attack.modifier(hero, context[:defender]) == +2
  end

  ## attack modifier - when a monk
  test "when a monk it adds wis modifier to attack modifier in addition to strength", context do
    {:ok, hero} = Hero.class(context[:subject], :monk)
    {:ok, hero} = Hero.Ability.score(hero, :str, 15)
    {:ok, hero} = Hero.Ability.score(hero, :wis, 15)
    assert Hero.Attack.modifier(hero, context[:defender]) == +4
  end
  test "when a monk it does not add negative wis modifier to attack modifier in addition to strength", context do
    {:ok, hero} = Hero.class(context[:subject], :monk)
    {:ok, hero} = Hero.Ability.score(hero, :str, 15)
    {:ok, hero} = Hero.Ability.score(hero, :wis, 4)
    assert Hero.Attack.modifier(hero, context[:defender]) == +2
  end
  test "when a monk it add +1 to attack modifier at every 2nd and 3rd level", context do
    Enum.each([{0, +0}, {1000, +1}, {2000, +2}, {3000, +2}, {4000, +3}, {5000, +4}], fn({xp, modifier}) ->
      {:ok, hero} = Hero.class(context[:subject], :monk)
      {:ok, hero} = Hero.Experience.add(hero, xp)
      assert Hero.Attack.modifier(hero, context[:defender]) == modifier
    end)
  end

  ## attack modifier - when a paladin
  test "when a paladin it has default attack modifier of +1", context do
    {:ok, hero} = Hero.alignment(context[:subject], :good)
    {:ok, hero} = Hero.class(hero, :paladin)
    assert Hero.Attack.modifier(hero, context[:defender]) == +1
  end
  test "when a paladin it add +1 to attack modifier at every level", context do
    Enum.each([{1000, +2}, {2000, +3}, {3000, +4}, {4000, +5}], fn({xp, modifier}) ->
      {:ok, hero} = Hero.alignment(context[:subject], :good)
      {:ok, hero} = Hero.class(hero, :paladin)
      {:ok, hero} = Hero.Experience.add(hero, xp)
      assert Hero.Attack.modifier(hero, context[:defender]) == modifier
    end)
  end

  ## attack modifier - when a paladin against an evil defender
  test "when a paladin attacking an evil character it adds +2 to attack modifuer", context do
    {:ok, hero} = Hero.alignment(context[:subject], :good)
    {:ok, hero} = Hero.class(hero, :paladin)
    {:ok, defender} = Hero.alignment(context[:defender], :evil)
    assert Hero.Attack.modifier(hero, defender) == +3
  end

  ## attack damage
  test "it has default attack damage of 1", context do
    assert Hero.Attack.damage(context[:subject], context[:defender]) == 1
  end
  test "it adds str modifier to attack damage", context do
    {:ok, hero} = Hero.Ability.score(context[:subject], :str, 15)
    assert Hero.Attack.damage(hero, context[:defender]) == 3
  end
  test "it cannot do less than 1 point of damage regardless of str modifier", context do
    {:ok, hero} = Hero.Ability.score(context[:subject], :str, 6)
    assert Hero.Attack.damage(hero, context[:defender]) == 1
  end

  ## attack damage - when a monk
  test "it has default attack damage of 3 when a monk", context do
    {:ok, hero} = Hero.class(context[:subject], :monk)
    assert Hero.Attack.damage(hero, context[:defender]) == 3
  end

  ## attack damage - when a paladin against an evil defender
  test "when a paladin attacking an evil character it have an attack damage of 3", context do
    {:ok, hero} = Hero.alignment(context[:subject], :good)
    {:ok, hero} = Hero.class(hero, :paladin)
    {:ok, defender} = Hero.alignment(context[:defender], :evil)
    assert Hero.Attack.damage(hero, defender) == 3
  end

  ## attack damage - when a paladin against a non-evil defender
  test "when a paladin attacking a non-evil character it have an attack damage of 1", context do
    {:ok, hero} = Hero.alignment(context[:subject], :good)
    {:ok, hero} = Hero.class(hero, :paladin)
    assert Hero.Attack.damage(hero, context[:defender]) == 1
  end

  ## critical damage
  test "it has default critical damage of 2", context do
    assert Hero.Attack.critical_damage(context[:subject], context[:defender]) == 2
  end
  test "it adds double the str modifier to attack damage", context do
    {:ok, hero} = Hero.Ability.score(context[:subject], :str, 15)
    assert Hero.Attack.critical_damage(hero, context[:defender]) == 6
  end
  test "it cannot do less than 1 point of damage on a crit regardless of str modifier", context do
    {:ok, hero} = Hero.Ability.score(context[:subject], :str, 6)
    assert Hero.Attack.critical_damage(hero, context[:defender]) == 1
  end

  ## critical damage - when a rogue
  test "when a rogue it has default critical damage of 3", context do
    {:ok, hero} = Hero.class(context[:subject], :rogue)
    assert Hero.Attack.critical_damage(hero, context[:defender]) == 3
  end

  ## critical damage - when a paladin against an evil defender
  test "when a paladin attacking an evil character it has a critical damage of 9", context do
    {:ok, hero} = Hero.alignment(context[:subject], :good)
    {:ok, hero} = Hero.class(hero, :paladin)
    {:ok, defender} = Hero.alignment(context[:defender], :evil)
    assert Hero.Attack.critical_damage(hero, defender) == 9
  end

  ## critical damage - when a paladin against an non-evil defender
  test "when a paladin attacking a non-evil character it has a critical damage of 2", context do
    {:ok, hero} = Hero.alignment(context[:subject], :good)
    {:ok, hero} = Hero.class(hero, :paladin)
    assert Hero.Attack.critical_damage(hero, context[:defender]) == 2
  end

end
