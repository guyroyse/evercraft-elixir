defmodule Hero do

  def create() do
    %{
      name: "",
      alignment: :neutral,
      damage: 0,
      str: Ability.create(),
      dex: Ability.create(),
      con: Ability.create(),
      wis: Ability.create(),
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
    class_and_alignment(hero, value, Hero.alignment(hero))
  end

  def alignment(hero) do
    hero.alignment
  end

  def alignment(hero, value) do
    class_and_alignment(hero, Hero.class(hero), value)
  end

  defp class_and_alignment(hero, class, alignment) do
    case valid_class_alignment_and_combo?(class, alignment) do
      {true, true, true} -> {:ok, %{hero | class: class, alignment: alignment}}
      {false, true, _} -> {:error, "invalid class"}
      {true, false, _} -> {:error, "invalid alignment"}
      {_, _, _} -> {:error, "invalid class and alignment"}
    end
  end

  defp valid_class_alignment_and_combo?(class, alignment) do
    {
      valid_class?(class),
      valid_alignment?(alignment),
      valid_class_alignment_combo?(class, alignment)
    }
  end

  defp valid_alignment?(value) do
    value_in_list([:good, :neutral, :evil], value)
  end

  defp valid_class?(value) do
    value_in_list([:no_class, :fighter, :rogue, :monk, :paladin], value)
  end

  defp valid_class_alignment_combo?(class, alignment) do
    case {class, alignment} do
      {:rogue, :good} -> false
      {:paladin, :evil} -> false
      {:paladin, :neutral} -> false
      {_, _} -> true
    end
  end

  defp value_in_list(list, value) do
    list |> Enum.filter(&(&1 == value)) |> Enum.empty? == false
  end

end
