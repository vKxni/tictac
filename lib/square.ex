defmodule Square do
  @board_size Board.size()
  @max_pos Board.max_pos()

  @enforce_keys [:pos]
  defstruct [:x, :y, :val, :pos]

  #  attempt to check if the given value of %Square{val: v} is empty.
  def is_empty?(%Square{val: v}), do: !v

  # create a new instance of the class "Square" with the given position.
  def new(pos) when pos in 1..@max_pos do
    %Square{pos: pos, y: y(pos), x: x(pos)}
  end

  # attempts to iterate through the list of numbers in a range.
  def x(pos), do: rem(pos - 1, @board_size) + 1
  def y(pos), do: div(pos - 1, @board_size) + 1

  # iterating over the list of squares, and updating each square's value based on its position.
  def update_at(squares, pos, value) do
    # update their values if they are equal to pos
    Enum.map(squares, fn square ->
      if square.pos == pos do
        # return a list of all the updated squares.
        %Square{square | val: value}
      end
    end)
  end
end
