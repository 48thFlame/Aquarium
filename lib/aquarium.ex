defmodule Aquarium do
  @moduledoc """
  Documentation for `Aquarium`.
  This module should be able to generate an Aquarium and also update it
  """
  alias Aquarium.Thing

  defstruct dim: {10, 20}, top: [], things: [], bottom: []

  @type t() :: %__MODULE__{
          dim: coords(),
          top: list(Thing.t()),
          things: list(Thing.t()),
          bottom: list(Thing.t())
        }

  @type coords() :: {integer(), integer()}

  @top_weight 0.3

  @fish_weight 0.2
  @fish_special_weight 0.19
  @fish_speed {0.08, 0.2}

  @bubble_weight 0.05
  @bubble_speed {0.09, 0.24}

  @bottom_weight 0.8
  @bottom_special_weight 0.12

  @empty "\u3000"

  defguardp is_valid_dim_num(num) when is_integer(num) and num > 2

  defguard is_valid_dim(dim)
           when is_valid_dim_num(elem(dim, 0)) and is_valid_dim_num(elem(dim, 1))

  @spec random_weight(float()) :: boolean()
  defp random_weight(weight) when is_float(weight) do
    rand = :rand.uniform()

    rand < weight
  end

  def random_range({min, max}) do
    :rand.uniform() * (max - min) + min
  end

  @spec new(coords()) :: Aquarium.t()
  def new(dim = {rows_num, cols_num})
      when is_valid_dim(dim) do
    top = generate_top(dim)
    things = generate_things({rows_num - 1, cols_num})
    bottom = generate_bottom(dim)

    %Aquarium{
      dim: dim,
      top: top,
      things: things,
      bottom: bottom
    }
  end

  defp generate_top(dim = {_, cols_num}) when is_valid_dim(dim) do
    for col <- 0..(cols_num - 1) do
      if random_weight(@top_weight) do
        Thing.new({0, col}, :top)
      end
    end
    |> Enum.reject(&is_nil/1)
  end

  defp generate_things(dim = {rows_num, cols_num}) when is_valid_dim(dim) do
    # starts at 1 to give 0 to top, - 2 because - 1 for index + - 1 for bottom - EDIT: need not - 2 what? why? i don't understand but it works like this
    for row <- 1..(rows_num - 1) do
      for col <- 0..(cols_num - 1) do
        pos = {row, col}

        if random_weight(@bubble_weight) do
          Thing.new(pos, :bubble, random_range(@bubble_speed))
        else
          if random_weight(@fish_weight) do
            speed =
              if random_weight(0.5) do
                1
              else
                -1
              end * random_range(@fish_speed)

            if random_weight(@fish_special_weight) do
              Thing.new(pos, :special_fish, speed)
            else
              Thing.new(pos, :fish, speed)
            end
          end
        end
      end
      |> Enum.reject(&is_nil/1)
    end
    |> List.flatten()
  end

  @spec generate_things(coords()) :: [Thing.t()]
  defp generate_bottom(dim = {rows_num, cols_num}) when is_valid_dim(dim) do
    for col <- 0..(cols_num - 1) do
      if random_weight(@bottom_weight) do
        pos = {rows_num - 1, col}

        if random_weight(@bottom_special_weight) do
          Thing.new(pos, :special_bottom)
        else
          Thing.new(pos, :bottom)
        end
      end
    end
    |> Enum.reject(&is_nil/1)
  end

  @doc """
  display(aquarium) - takes and %Aquarium{} as input and returns a string - its display.

  Algorithm: create a big 1-d list representing every cell in the grid (of size rows*cols)
    replace every item place with a thing
      and join everything together.
  """
  @spec display(t()) :: String.t()
  def display(%Aquarium{dim: {rows_num, cols_num}, top: top, things: things, bottom: bottom}) do
    List.duplicate(@empty, rows_num * cols_num)
    |> replace_empty_with_things(top ++ things ++ bottom, cols_num)
    |> Enum.chunk_every(cols_num)
    |> Enum.map(fn row -> row ++ ["\n"] end)
    |> Enum.map(fn row -> Enum.join(row, " ") end)
    |> List.flatten()
    |> Enum.join()
  end

  # base case - things is an empty list - put everyone in place.
  # regular case - thing is still in the aquarium - put it in the acc
  # edge case - thing is out of bounds - take it out and ignore
  # (shouldn't be a need for edge case - should filter them out before calling this function)
  defp replace_empty_with_things(list_acc, [], _), do: list_acc

  defp replace_empty_with_things(
         list_acc,
         [%Thing{pos: {row, col}, face: face} | rest],
         cols_num
       )
       when row >= 0 and col >= 0 do
    row = round(row)
    col = round(col)

    i = cols_num * (row + 1) + col - cols_num

    list_acc = List.replace_at(list_acc, i, face)

    replace_empty_with_things(list_acc, rest, cols_num)
  end

  defp replace_empty_with_things(
         list_acc,
         [%Thing{pos: {row, col}} | rest],
         cols_num
       )
       when row < 0 or col < 0 do
    replace_empty_with_things(list_acc, rest, cols_num)
  end

  @spec update(Aquarium.t()) :: Aquarium.t()
  def update(aquarium = %Aquarium{top: top, things: things, bottom: _bottom}) do
    %Aquarium{
      aquarium
      | top: update_things(top, aquarium),
        things: update_things(things, aquarium)
    }
  end

  @spec update_things([Thing.t()], t()) :: [Thing.t()]
  defp update_things(things, %Aquarium{dim: dim}) do
    things
    |> Enum.map(&update_thing(&1, dim))
    |> filter_things(dim)
  end

  @spec update_thing(Thing.t(), coords()) :: Thing.t()
  defp update_thing(thing = %Thing{id: id}, {_rows_num, _cols_num}) do
    if id == :bubble do
      Thing.move_up_down(thing)
    else
      Thing.move_left_right(thing)
    end
  end

  @spec filter_things([Thing.t()], coords()) :: [Thing.t()]
  defp filter_things(things, dim) do
    Enum.reject(things, &out_of_bounds?(&1, dim))
  end

  @spec out_of_bounds?(Thing.t(), coords()) :: boolean()
  defp out_of_bounds?(%Thing{pos: {row, col}}, {rows_num, cols_num}) do
    row < 0 or row >= rows_num or col < 0 or col >= cols_num
  end
end
