defmodule Ability do

  def create() do
    %{ score: 10 }
  end

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
