defmodule Aquarium do
  @moduledoc """
  Documentation for `Aquarium`.
  This module should be able to generate an Aquarium and also update it
  """

  @fish ["🐠", "🐟", "🐡"]
  @special_fish ["🐙", "🐬", "🐋", "🦈", "🦑", "🦐", "🪼"]

  @floor ["🪸", "🌿", "🌱", "🌾"]
  @special_floor ["🦀", "🦞", "🐚", "🏰", "🪨", "🐌", "💰", "💎", "☘️", "⚓", "🔱", "🗿"]

  # maybe also? "🐳", "🛟", "🧜🏻‍♀️"
  @top ["🌊", "⛵", "🏊", "🏄", "🚣", "🚤", "🚢", "⛴️"]

  @bubble "🫧"
  # 🟦
  @empty "\u3000"

  @top_weight 0.3

  @level_weight 0.2
  @level_special_weight 0.19

  @bubble_weight 0.05

  @floor_weight 0.8
  @floor_special_weight 0.12

  defp random_weight(weight) when is_float(weight) do
    rand = :rand.uniform()

    if rand < weight do
      true
    else
      false
    end
  end

  def clear_screen do
    IO.write([IO.ANSI.home(), IO.ANSI.clear()])
  end

  def term_dimensionns do
    {:ok, width} = :io.columns()
    {:ok, height} = :io.rows()
    {width, height}
  end

  def gen_top(width) when is_integer(width) and width >= 2 do
    (for _col <- 1..width do
       if random_weight(@top_weight) do
         Enum.random(@top)
       else
         @empty
       end
     end
     |> Enum.join(" ")) <> "\n"
  end

  def gen_bottom(width) when is_integer(width) and width >= 2 do
    (for _col <- 1..width do
       # checks if should gen item
       if random_weight(@floor_weight) do
         special = random_weight(@floor_special_weight)

         # checks if should be special item
         if special do
           Enum.random(@special_floor)
         else
           Enum.random(@floor)
         end
       else
         @empty
       end
     end
     |> Enum.join(" ")) <> "\n"
  end

  def gen_level(width) when is_integer(width) and width >= 2 do
    (for _col <- 1..width do
       if random_weight(@bubble_weight) do
         @bubble
       else
         # checks if should gen item
         if random_weight(@level_weight) do
           special = random_weight(@level_special_weight)

           # checks if should be special item
           if special do
             Enum.random(@special_fish)
           else
             Enum.random(@fish)
           end
         else
           @empty
         end
       end
     end
     |> Enum.join(" ")) <> "\n"
  end

  def gen_aquarium(width, height) when is_integer(width) and is_integer(height) and height >= 3 do
    top = gen_top(width)
    bottom = gen_bottom(width)

    levels =
      for _row <- 1..(height - 2) do
        gen_level(width)
      end
      |> Enum.join()

    (top <> levels <> bottom) |> String.trim()
  end

  def main do
    dim = term_dimensions() |> IO.inspect()
    width = elem(dim, 0) |> div(3)
    height = elem(dim, 1) - 1

    for _i <- 1..100 do
      aquarium = gen_aquarium(width, height)
      clear_screen()

      IO.puts(aquarium)
      Process.sleep(1000)

    end
  end
end

Aquarium.main()
