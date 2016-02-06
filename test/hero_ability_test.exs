defmodule HeroAbilityTest do
  use ExUnit.Case

  setup do
    {:ok, subject: Hero.create() }
  end

  test "it has expected abilities", context do
    Enum.each([:str, :dex, :con, :int, :wis, :cha], fn(ability) ->
      assert Hero.Ability.score(context[:subject], ability) == 10
    end)
  end
  test "it has settable abilities", context do
    Enum.each([:str, :dex, :con, :int, :wis, :cha], fn(ability) ->
      {:ok, hero} = Hero.Ability.score(context[:subject], ability, 15)
      assert Hero.Ability.score(hero, ability) == 15
    end)
  end
  test "it complains about out of range abilities", context do
    Enum.each([:str, :dex, :con, :int, :wis, :cha], fn(ability) ->
      {:error, reason} = Hero.Ability.score(context[:subject], ability, 25)
      assert reason == "invalid score"
    end)
  end
  test "it has expected ability modifiers", context do
    Enum.each([:str, :dex, :con, :int, :wis, :cha], fn(ability) ->
      {:ok, hero} = Hero.Ability.score(context[:subject], ability, 15)
      assert Hero.Ability.modifier(hero, ability) == +2
    end)
  end

  ## when an orc
  test "when an orc, it has a +2 to str modifier", context do
    {:ok, hero} = Hero.race(context[:subject], :orc)
    assert Hero.Ability.modifier(hero, :str) == +2
  end
  test "when an orc, it has a -1 to int modifier", context do
    {:ok, hero} = Hero.race(context[:subject], :orc)
    assert Hero.Ability.modifier(hero, :int) == -1
  end
  test "when an orc, it has a -1 to wis modifier", context do
    {:ok, hero} = Hero.race(context[:subject], :orc)
    assert Hero.Ability.modifier(hero, :wis) == -1
  end
  test "when an orc, it has a -1 to cha modifier", context do
    {:ok, hero} = Hero.race(context[:subject], :orc)
    assert Hero.Ability.modifier(hero, :cha) == -1
  end

end
