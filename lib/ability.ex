defmodule AbilityData do
  defstruct score: 10
end

defprotocol Ability do
  def score(ability)
  def score(ability, value)
  def modifier(ability)
end

defimpl Ability, for: AbilityData do

  def score(ability) do
    ability.score
  end

  def score(ability, value) when value >= 1 and value <= 20 do
    {:ok, %{ability | score: value}}
  end

  def score(_, _) do
    {:error, "invalid score"}
  end

  def modifier(ability) do
    div(ability.score, 2) - 5
  end

end
