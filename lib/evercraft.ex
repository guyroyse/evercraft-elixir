defmodule HeroData do
  defstruct name: "", alignment: :neutral
end

defprotocol Hero do
  def name(hero)
  def name(hero, value)
  def alignment(hero)
  def alignment(hero, value)
  def armor_class(hero)
  def hit_points(hero)
end

defimpl Hero, for: HeroData do

  def name(hero) do
    hero.name
  end

  def name(hero, value) do
    {:ok, %{hero | name: value}}
  end

  def alignment(hero) do
    hero.alignment
  end

  def alignment(hero, value) do
    cond do
      valid_alignment? value -> {:ok, %{hero | alignment: value}}
      true -> {:error, "invalid alignment"}
    end
  end

  def armor_class(hero) do
    10
  end

  def hit_points(hero) do
    5
  end

  defp valid_alignment?(value) do
    [:good, :neutral, :evil] |> Enum.filter(&(&1 == value)) |> Enum.empty? == false
  end

end
