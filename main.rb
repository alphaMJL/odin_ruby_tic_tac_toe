# Initialize Player attributes
class Player
  attr_reader :name, :marker

  def initialize(name, marker)
    @name = name
    @marker = marker
  end
end

# Board state and draw method
class Board
  attr_accessor :board_state

  def initialize
    @board_state = %w[1 2 3 4 5 6 7 8 9]
  end

  def draw_board
    "| #{board_state[0]} | #{board_state[1]} | #{board_state[2]} |\n| #{board_state[3]} | #{board_state[4]} | #{board_state[5]} |\n| #{board_state[6]} | #{board_state[7]} | #{board_state[8]} |\n"  
  end

  def reset_board
    @board_state = %w[1 2 3 4 5 6 7 8 9]
  end
end

# gameplay loop and methods
class Game
  def initialize
    @player_1 = Player.new('Player 1 - Circle', 'O')
    @player_2 = Player.new('Player 2 - X', 'X')
    @current_player = @player_1
    @game_board = Board.new
    @current_move = ''
    @is_game_over = false
    @winner = nil
  end

  def reset_game
    @current_player = @player_1
    @winner = nil
    @is_game_over = false
    @game_board.reset_board
  end

  def check_for_winner
    winning_combinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],  # Horizontal
      [0, 3, 6], [1, 4, 7], [2, 5, 8],  # Vertical
      [0, 4, 8], [2, 4, 6]              # Diagonal
    ]
    winning_combinations.each do |combo|
      if @game_board.board_state[combo[0]] == @game_board.board_state[combo[1]]  && @game_board.board_state[combo[1]] == @game_board.board_state[combo[2]]
        @winner = @current_player.name
        @is_game_over = true

      end

      if !@game_board.board_state.any? {|item| item.match(/^[1-9]$/)}
        @winner = 'Draw'
        @is_game_over = true
      end
    end
  end

  # end of game play again
  def play_again
    puts "\n\nPlay again?"
    puts 'Y to play again, X to quit'
    play = gets.chomp
    until play =~ /^[YyXx]$/
      puts 'Y to play again, X to quit'
      play = gets.chomp
    end

    if play.downcase == 'y'
      @game_board.reset_board
      reset_game
      start_game
    else
      exit
    end
  end

  # take input from player and validate
  def get_move
    puts 'Please enter a a number 1-9'
    current_input = gets.chomp
    while !(current_input =~ /^[1-9]$/) || !(@game_board.board_state[current_input.to_i - 1] =~ /^[1-9]$/)
      puts 'Invalid input. Please enter a valid number 1-9 to choose your move.'
      current_input = gets.chomp
    end
    current_input.to_i
  end

  # end of turn player switch
  def switch_players
    if @current_player == @player_1
      @current_player = @player_2
    else
      @current_player = @player_1
    end
  end

  # draw new board
  def update_board_state
    @game_board.board_state[@current_move - 1] = @current_player.marker
  end

  # end game message
  def display_result
    if @winner == 'Draw'
      puts 'Draw! It was a tie!'
    else
      puts "The winner is #{@winner}, Congratulations!"
    end
  end

  # new game loop
  def start_game
    system 'clear'
    puts 'Welcome to Tic-Tac Toe! \n\n'
    puts @game_board.draw_board
    puts "\n\nCircle player goes first!\n"
    while @is_game_over == false
      @current_move = get_move
      update_board_state
      check_for_winner
      system 'clear'
      puts 'Welcome to Tic-Tac Toe! \n\n'
      puts @game_board.draw_board
      switch_players
      puts "\n\n#{@current_player.name}'s turn"
    end
    display_result
    play_again
  end
end

new = Game.new
new.start_game
