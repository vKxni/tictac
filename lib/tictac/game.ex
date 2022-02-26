defmodule TicTac.Game do
  alias __MODULE__

  # create a board with three players, and the winner will be the player who has made the most moves.
  @board_size Board.size()
  @max_pos Board.max_pos()

  defstruct [:board, :current_player, :winner, :move]

  # end the turn of the current player in a game.
  def end_turn(%Game{board: board, current_player: player} = game) do

    # checks if there is an opponent left on the board
    case {game.winner, Board.is_full?(board)} do
      {true, _} ->
        Board.print(board)
        player_str = player |> to_string() |> String.upcase()
        "Game over. #{player_str} is victorious!"

      {_, true} ->
        Board.print(board)
        "Game over. It's a tie."

      # takes in player as an argument and returns another player object with that player's name as its value.
      _ ->
        player = other_player(player)
        main_loop(%Game{game | move: nil, current_player: player})
    end
  end

  def get_move(%Game{} = game) do

    # printing the board
    Board.print(game.board)

    # gets a string from the user, which is trimmed and parsed into an integer
    move =
      IO.gets("Choose your next square (1-#{@max_pos}) ")
      |> String.trim()
      |> Integer.parse()

    # The case statement checks if that number is in 1-@max_pos, which means it's one of the squares on the board.
    # If so, then it sets up a new game object with that square as its move value.
    case move do
      {move, _} when move in 1..@max_pos -> %Game{game | move: move}
      _ -> get_move(game)
    end
  end

  # trying to find the player who is playing on a given square.
  def play_move(%Game{} = game) do

    # If that square is occupied, it prints "Square is occupied!" and then moves onto the next player.
    case Board.at(game.board, game.move) do
      %{val: nil} ->
        update_square(game)
    # sets the current_player variable to that other player, and then runs through all possible moves for that player.
    # If there are no legal moves for that player, it will print "Square is occupied!"
      _ ->
        IO.puts("Square is occupied!")
        player = other_player(game.current_player)
        %Game{game | current_player: player}
    end
  end

  def main_loop(%Game{} = game) do
    game
    |> get_move()
    |> play_move()
    |> win_check()
    |> end_turn()
  end

  # creates a new Board object with no players on it, then sets the current_player to be player1.

  def new(player1), do: %Game{board: Board.new(), current_player: player1}

  # defines another function called other_player which takes one parameter: x or o depending on what's passed in as its first argument.
  # If you pass in :x as your first argument, then this will set up an else clause for when you pass in :o as your first argument.
  # Then if you pass in anything else than those two values (or any value), it will return an error message saying "other_player(_)".

  def other_player(:x), do: :o
  def other_player(:o), do: :x
  def other_player(_), do: :error

  # recursive function.
  def start(player1) when player1 in [:x, :o] do
    new(player1) |> main_loop()
  end

  def start(_), do: "Invalid player!"

  def update_square(%Game{board: b, current_player: player, move: move} = game) do
    new_squares = Square.update_at(b.squares, move, player)
    %Game{game | board: %Board{b | squares: new_squares}}
  end

  def win_check(%Game{} = game) do
    winner = check_lines(game, [:col, :row, :asc_diag, :desc_diag])
    %Game{game | winner: winner}
  end

  # Win check-related utilities
  def check_line(%Game{} = game, direction) do
    get_line(game.board.squares, direction, game.move)
    |> Enum.all?(fn square -> square.val == game.current_player end)
  end

  def check_lines(%Game{} = game, directions) do
    Enum.any?(directions, fn dir -> check_line(game, dir) end)
  end

  def make_col_filter(pos), do: fn s -> s.x == Square.x(pos) end
  def make_row_filter(pos), do: fn s -> s.y == Square.y(pos) end
  def asc_diag_filter(square), do: square.x + square.y == @board_size + 1
  def desc_diag_filter(square), do: square.x - square.y == 0

  def get_line(squares, direction, pos) do
    filter =
      case direction do
        :col -> make_col_filter(pos)
        :row -> make_row_filter(pos)
        :asc_diag -> &asc_diag_filter/1
        :desc_diag -> &desc_diag_filter/1
      end

    Enum.filter(squares, filter)
  end
end
