defmodule Hero.Experience do

  def points(hero) do
    hero.experience
  end

  def level(hero) do
    div(hero.experience, 1000) + 1
  end

  def add(hero, points) do
    {:ok, %{hero | experience: hero.experience + points}}
  end

end
