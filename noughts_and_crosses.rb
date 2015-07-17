require_relative 'cell.rb'
require_relative 'board_builder.rb'
require_relative 'output.rb'
require_relative 'players/base.rb'
require_relative 'strategy.rb'
require_relative 'players/ai/random.rb'
require_relative 'players/ai/win_block_or_optimal.rb'
require_relative 'players/human.rb'

# TODO
# Introduce WinningRow model and redesign solution. Currently, winning rows are recalculated
# on each move, which is not very time-complexity efficient. Instead, from start each player can have
# a set of potential winning rows. And each player's move should reduce opponent's winning rows
# from their set. However, this would take more space.

module NoughtsAndCrosses
  class Game
    include BoardBuilder
    include Output
    PLAYER_STRATEGIES = %w(human win_block_or_optimal random).freeze

    attr_reader :winner_row, :active_player, :board, :tokens

    def initialize(rows_size, cols_size, winning_row_size)
      @rows_size = rows_size
      @cols_size = cols_size
      @winning_row_size = winning_row_size
      @board = generate_board

      @winning_rows = horizontal_win_rows + vertical_win_rows +
                      diagonal_top_left_row_wins + diagonal_bottom_left_row_wins

      @winning_rows.each do |cells|
        cells.each(&:increment_weight)
      end

      @players = []
      @tokens = []
    end

    def add_player(player)
      fail "Player can't go with blank tokens" if player.token.nil?
      player.game = self
      @tokens.push(player.token)
      @players.push(player)
    end

    # Initial players' alignment. Simplified implementation based on fact that the game is likely to be
    # played with 'x' and 'o'. Can be anything though, and thus this method is ready to be extended.
    def align_players
      @players.sort_by!(&:token).reverse!
    end

    def set_active_player
      @active_player = @players.shift
    end

    def prepare
      align_players
      set_active_player
    end

    def pass_turn
      @players.push(@active_player)
      @active_player = @players.shift
    end

    def start
      prepare
      print_board

      loop do
        @active_player.make_move

        if game_over?
          print_board
          break
        end
        print_board
        pass_turn
      end
    end

    def almost_won_rows(token)
      available_win_rows(token).select do |row|
        row.select(&:vacant?).size == almost_won_vacant_cells_count
      end
    end

    def almost_won_row(token)
      almost_won_rows(token).first
    end

    def almost_won_vacant_cells_count
      # @cols_size * @rows_size < @winning_row_size ** 2
      @winning_row_size < @cols_size || @winning_row_size < @rows_size ? 2 : 1
    end

    def almost_lost_row(token)
      opponent_tokens = @tokens - [token]

      row = nil
      opponent_tokens.each do |opponent_token|
        row = almost_won_row(opponent_token)
        break if row
      end
      row
    end

    def available_win_rows(token)
      @winning_rows.select { |row| row.all? { |c| c.vacant? || c.token == token } }
    end

    def game_over?
      @tokens.each do |token|
        @winner_row = @winning_rows.find { |row| row.all? { |cell| cell.token == token } }
        if @winner_row
          @winner_token = @winner_row.first.token
          return true
        end
      end
      draw?
    end

    # TODO
    # 'draw' can be detected at early stages as absence of potential winning rows
    def draw?
      board_cells.select(&:vacant?).size == 0
    end
  end
end
