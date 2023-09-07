defmodule Aquarium.Thing do
  alias Aquarium.Thing
  defstruct pos: {0, 0}, id: nil, speed: 0, face: ""

  @type t() :: %__MODULE__{
          pos: {number(), number()},
          id: atom(),
          speed: number(),
          face: String.t()
        }

  @fish ["🐠", "🐟", "🐡"]
  @special_fish ["🐙", "🐬", "🐋", "🦈", "🦑", "🦐", "🪼"]

  @bottom ["🪸", "🌿", "🌱", "🌾"]
  @special_bottom ["🦀", "🦞", "🐚", "🏰", "🪨", "🐌", "💰", "💎", "☘️", "⚓", "🔱", "🗿"]

  # maybe also? "🐳", "🛟", "🧜🏻‍♀️"
  @top ["🌊", "⛵", "🏊", "🏄", "🚣", "🚤", "🚢", "⛴️"]

  @bubble "🫧"
  # 🟦
  # @empty "\u3000"

  @spec new(any, :bottom | :bubble | :fish | :special_bottom | :special_fish | :top, number) ::
          Aquarium.Thing.t()
  @doc """
    new() creates a new thing
  """
  def new(pos, id, speed \\ 0)

  def new(pos, id = :fish, speed) do
    new(pos, id, Enum.random(@fish), speed)
  end

  def new(pos, id = :special_fish, speed) do
    new(pos, id, Enum.random(@special_fish), speed)
  end

  def new(pos, id = :bottom, speed) do
    new(pos, id, Enum.random(@bottom), speed)
  end

  def new(pos, id = :special_bottom, speed) do
    new(pos, id, Enum.random(@special_bottom), speed)
  end

  def new(pos, id = :top, speed) do
    new(pos, id, Enum.random(@top), speed)
  end

  def new(pos, id = :bubble, speed) do
    new(pos, id, @bubble, speed)
  end

  def new(pos, id, face, speed)
      when is_atom(id) and is_number(speed) and is_binary(face) do
    %__MODULE__{
      pos: pos,
      id: id,
      speed: speed,
      face: face
    }
  end

  @doc """
    move_up_down(thing) returns a new Thing such that its row-pos was moved by speed.
  """
  @spec move_up_down(t()) :: t()
  def move_up_down(thing = %Thing{pos: {row, col}, speed: speed}) do
    # - so positive speed moves up
    %Thing{thing | pos: {row - speed, col}}
  end

  @spec move_left_right(t()) :: t()
  def move_left_right(thing = %Thing{pos: {row, col}, speed: speed}) do
    %Thing{thing | pos: {row, col + speed}}
  end
end
