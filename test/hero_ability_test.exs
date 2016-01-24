defmodule HeroAbilityTest do
  use ExUnit.Case

  setup do
    {:ok, subject: Hero.create() }
  end

  test "it has expected abilities", context do
    Enum.each([:str, :dex, :con], fn(ability) ->
      assert Hero.Ability.score(context[:subject], ability) == 10
    end)
  end
  test "it has settable abilities", context do
    Enum.each([:str, :dex, :con], fn(ability) ->
      {:ok, hero} = Hero.Ability.score(context[:subject], ability, 15)
      assert Hero.Ability.score(hero, ability) == 15
    end)
  end
  test "it complains about out of range abilities", context do
    Enum.each([:str, :dex, :con], fn(ability) ->
      {:error, reason} = Hero.Ability.score(context[:subject], ability, 25)
      assert reason == "invalid score"
    end)
  end
  test "it has expected ability modifiers", context do
    Enum.each([:str, :dex, :con], fn(ability) ->
      {:ok, hero} = Hero.Ability.score(context[:subject], ability, 15)
      assert Hero.Ability.modifier(hero, ability) == +2
    end)
  end

end
