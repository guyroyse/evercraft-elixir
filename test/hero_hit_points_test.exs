defmodule HeroHitPointsTest do
  use ExUnit.Case

  setup do
    {:ok, subject: Hero.create() }
  end

  ## max hit points
  test "it has default max hit points of 5", context do
    assert Hero.HitPoints.current(context[:subject]) == 5
  end
  test "it has 5 max hit points per level", context do
    {:ok, hero} = Hero.Experience.add(context[:subject], 2000) ## level = 3
    assert Hero.HitPoints.current(hero) == 15
  end
  test "it adds con modifier to max hit points", context do
    {:ok, hero} = Hero.Ability.score(context[:subject], :con, 15)
    assert Hero.HitPoints.current(hero) == 7
  end
  test "it adds con modifier to max hit points for each level", context do
    {:ok, hero} = Hero.Experience.add(context[:subject], 2000) ## level = 3
    {:ok, hero} = Hero.Ability.score(hero, :con, 15)
    assert Hero.HitPoints.current(hero) == 21
  end
  test "it cannot have less than 1 max hit points regardless of con modifier", context do
    {:ok, hero} = Hero.Ability.score(context[:subject], :con, 1)
    assert Hero.HitPoints.current(hero) == 1
  end
  test "it cannot have less than 1 max hit points per level regardless of con modifier", context do
    {:ok, hero} = Hero.Experience.add(context[:subject], 2000) ## level = 3
    {:ok, hero} = Hero.Ability.score(hero, :con, 1)
    assert Hero.HitPoints.current(hero) == 3
  end

  ## max hit points - when a fighter
  test "when a fighter, it has default max hit points of 10", context do
    {:ok, hero} = Hero.class(context[:subject], :fighter)
    assert Hero.HitPoints.current(hero) == 10
  end
  test "when a fighter, it has 10 max hit points per level", context do
    {:ok, hero} = Hero.class(context[:subject], :fighter)
    {:ok, hero} = Hero.Experience.add(hero, 2000) ## level = 3
    assert Hero.HitPoints.current(hero) == 30
  end

  ## max hit points - when a monk
  test "when a monk, it has default max hit points of 6", context do
    {:ok, hero} = Hero.class(context[:subject], :monk)
    assert Hero.HitPoints.current(hero) == 6
  end
  test "when a monk, it has 6 max hit points per level", context do
    {:ok, hero} = Hero.class(context[:subject], :monk)
    {:ok, hero} = Hero.Experience.add(hero, 2000) ## level = 3
    assert Hero.HitPoints.current(hero) == 18
  end

  ## max hit points - when a paladin
  test "when a paladin, it has default max hit points of 8", context do
    {:ok, hero} = Hero.alignment(context[:subject], :good)
    {:ok, hero} = Hero.class(hero, :paladin)
    assert Hero.HitPoints.current(hero) == 8
  end
  test "when a paladin, it has 8 max hit points per level", context do
    {:ok, hero} = Hero.alignment(context[:subject], :good)
    {:ok, hero} = Hero.class(hero, :paladin)
    {:ok, hero} = Hero.Experience.add(hero, 2000) ## level = 3
    assert Hero.HitPoints.current(hero) == 24
  end

  ## hit points
  test "it has max hit points as hit point when undamaged", context do
    assert Hero.HitPoints.current(context[:subject]) == 5
  end
  test "it goes down when damaged", context do
    {:ok, hero} = Hero.HitPoints.damage(context[:subject], 3)
    assert Hero.HitPoints.current(hero) == 2
  end

  ## alive?
  test "it is alive when undamaged", context do
    assert Hero.HitPoints.alive?(context[:subject]) == true
  end
  test "it is alive when damaged but not to 0 hit points", context do
    {:ok, hero} = Hero.HitPoints.damage(context[:subject], 2)
    assert Hero.HitPoints.alive?(hero) == true
  end
  test "it is dead when damaged to 0 hit points", context do
    {:ok, hero} = Hero.HitPoints.damage(context[:subject], 5)
    assert Hero.HitPoints.alive?(hero) == false
  end
  test "it is dead when damaged to below 0 hit points", context do
    {:ok, hero} = Hero.HitPoints.damage(context[:subject], 10)
    assert Hero.HitPoints.alive?(hero) == false
  end

end
