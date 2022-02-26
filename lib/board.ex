defmodule Board do
  @board_size 3
  def size, do: @board_size

  @max_pos @board_size * @board_size
  def max_pos, do: @max_pos

  defstruct squares: []

  # iterate through the squares of a board, and then return the square that is n-1 away from the current square.
  def at(%Board{squares: squares}, n) when is_integer(n) do
    Enum.at(squares, n - 1 )
  end

  # return true if the board is full, and false otherwise.
  def is_full?(%Board{squares: squares}) do
    not Enum.any?(squares, &Square.is_empty?/1)
  end

  # create a new board object with the squares as an enumerable of size 1..@max_pos
  def new do
    %Board{squares: Enum.map(1..@max_pos, &Square.new/1)}
  end

  # printing the squares on a chess board.
  # starts by creating an empty string, then prints each square in order until it reaches the end of the board.
  # prints the board size and then prints each square on the board.
  def print(%Board{squares: squares}) do
    IO.puts("")

    squares
    |> Enum.chunk_every(@board_size)
    |> Enum.each(&print_line/1)

    IO.puts("")
  end

  # first line is printing the bars on the left side of the board, then it prints each square in order by row and column.
  # print_line/1 which takes an array as input and prints out each element in that array separated by spaces.
  #
  def print_line(squares) do
    bars = String.duplicate("-", @board_size * 4 - 1)

    # checks if there are any rows or columns where y is greater than one, and if so it prints "|" followed by all those elements (the bars for that row or column).
    if hd(squares).y > 1, do: IO.puts(bars)

    # printing out a line for each square on the chess board.
    squares
    |> Enum.map(fn s -> s.val || " " end)
    |> Enum.join(" | ")
    |> pad()
    |> IO.puts()
  end

  def pad(str), do: " " <> str <> " "
end
