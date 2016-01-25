defmodule Hero do

  def create() do
    %{
      name: "",
      alignment: :neutral,
      damage: 0,
      str: Ability.create(),
      dex: Ability.create(),
      con: Ability.create(),
      experience: 0,
      class: :no_class
    }
  end

  def name(hero) do
    hero.name
  end

  def name(hero, value) do
    {:ok, %{hero | name: value}}
  end

  def class(hero) do
    hero.class
  end

  def class(hero, value) do
    case { valid_class?(value), valid_class_alignment_combo?(value, Hero.alignment(hero)) } do
      {true, true} -> {:ok, %{hero | class: value}}
      {true, false} -> {:error, "invalid class and alignment"}
      {_, _} -> {:error, "invalid class"}
    end
  end

  def alignment(hero) do
    hero.alignment
  end

  def alignment(hero, value) do
    case { valid_alignment?(value), valid_class_alignment_combo?(Hero.class(hero), value) } do
      {true, true} -> {:ok, %{hero | alignment: value}}
      {true, false} -> {:error, "invalid class and alignment"}
      {_, _} -> {:error, "invalid alignment"}
    end
  end

  def armor_class(hero) do
    10 + Hero.Ability.modifier(hero, :dex)
  end

  defp valid_alignment?(value) do
    value_in_list([:good, :neutral, :evil], value)
  end

  defp valid_class?(value) do
    value_in_list([:no_class, :fighter, :rogue], value)
  end

  defp valid_class_alignment_combo?(class, alignment) do
    case {class, alignment} do
      {:rogue, :good} -> false
      {_, _} -> true
    end
  end

  defp value_in_list(list, value) do
    list |> Enum.filter(&(&1 == value)) |> Enum.empty? == false
  end

end
