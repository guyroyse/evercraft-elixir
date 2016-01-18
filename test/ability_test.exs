defmodule AbilityTest do
  use ExUnit.Case

  setup do
    {:ok, subject: Ability.create() }
  end

  ## score
  test "it has a default score of 10", context do
    assert Ability.score(context[:subject]) == 10
  end
  test "it has a settable score", context do
    {:ok, ability} = Ability.score(context[:subject], 16)
    assert Ability.score(ability) == 16
  end
  test "it cannot be too low", context do
    {:error, reason} = Ability.score(context[:subject], 0)
    assert reason == "invalid score"
  end
  test "it cannot be too high", context do
    {:error, reason} = Ability.score(context[:subject], 21)
    assert reason == "invalid score"
  end

  ## modifier
  test "it has expected modifiers", context do
    Enum.each([
      {1, -5}, {2, -4}, {3, -4}, {4, -3}, {5, -3},
      {6, -2}, {7, -2}, {8, -1}, {9, -1}, {10, 0},
      {11, 0}, {12, +1}, {13, +1}, {14, +2}, {15, +2},
      {16, +3}, {17, +3}, {18, +4}, {19, +4}, {20, +5}
    ], fn({score, modifier}) ->
      {:ok, ability} = Ability.score(context[:subject], score)
      assert Ability.modifier(ability) == modifier
    end)
  end

end
