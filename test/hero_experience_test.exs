defmodule HeroExperienceTest do
  use ExUnit.Case

  setup do
    {:ok, subject: Hero.create() }
  end

  ## experience points
  test "it has default xp of 0", context do
    assert Hero.Experience.points(context[:subject]) == 0
  end
  test "experience can be added to", context do
    {:ok, hero} = Hero.Experience.add(context[:subject], 25)
    {:ok, hero} = Hero.Experience.add(hero, 25)
    assert Hero.Experience.points(hero) == 50
  end

  ## level
  test "it has a defauilt level of 1", context do
    assert Hero.Experience.level(context[:subject]) == 1
  end
  test "it goes up a level every 1000 experience points", context do
    Enum.each([{999, 1}, {1000, 2}, {1999, 2}, {2000, 3}], fn({xp, level}) ->
      {:ok, hero} = Hero.Experience.add(context[:subject], xp)
      assert Hero.Experience.level(hero) == level
    end)
  end

end
