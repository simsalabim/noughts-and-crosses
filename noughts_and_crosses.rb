require_relative 'cell.rb'
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
    PLAYER_STRATEGIES = %w(human win_block_or_optimal random).freeze

    attr_reader :winner_row, :active_player

    def initialize(rows_size, cols_size, winning_row_size)
      @rows_size = rows_size
      @cols_size = cols_size
      @winning_row_size = winning_row_size
      @cells = generate_cells

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

    def generate_cells
      cells = []
      for i in 0...@rows_size
        for j in 0...@cols_size
          cells.push(Cell.new(i, j))
        end
      end
      cells
    end

    def horizontal_win_rows
      rows = []
      for i in 0..@rows_size
        for j in 0..(@cols_size - @winning_row_size)
          jj = j
          row = []
          while jj < j + @winning_row_size
            row.push(cell_at(i, jj))
            jj += 1
          end
          rows.push(row) if row.any?
        end
      end
      rows
    end

    def vertical_win_rows
      rows = []
      for j in 0..@cols_size
        for i in 0..(@rows_size - @winning_row_size)
          ii = i
          row = []
          while ii < i + @winning_row_size
            row.push(cell_at(ii, j))
            ii += 1
          end
          rows.push(row) if row.any?
        end
      end
      rows
    end

    def diagonal_top_left_row_wins
      rows = []
      for i in 0..(@rows_size - @winning_row_size)
        for j in 0..(@cols_size - @winning_row_size)
          ii = i
          jj = j
          row = []
          @winning_row_size.times do
            row.push(cell_at(ii, jj))
            ii += 1
            jj += 1
          end
          rows.push(row) if row.any?
        end
      end
      rows
    end

    def diagonal_bottom_left_row_wins
      rows = []
      i = @rows_size - 1
      while i >= @winning_row_size - 1
        for j in 0..(@cols_size - @winning_row_size)
          ii = i
          jj = j
          row = []
          @winning_row_size.times do
            row.push(cell_at(ii, jj))
            ii -= 1
            jj += 1
          end
          rows.push(row) if row.any?
        end
        i -= 1
      end
      rows
    end

    def almost_won_row(token)
      available_win_rows(token).find do |row|
        if @winning_row_size < @cols_size || @winning_row_size < @rows_size
          row.select(&:vacant?).size == 2
        else
          row.select(&:vacant?).size == 1
        end
      end
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

    def cell_at(row, column)
      @cells.find { |cell| cell.row == row && cell.column == column }
    end

    def vacant_cells
      @cells.select(&:vacant?)
    end

    def occupy(cell, token)
      cell.token = token
    end

    def game_over?
      @tokens.each do |token|
        @winner_row = @winning_rows.find { |row| row.all? { |cell| cell.token == token } }
        if @winner_row
          @winner_token = @winner_row.first.token
          return true
        end
      end
      return true if draw?
      false
    end

    # TODO
    # 'draw' can be detected at early stages as absence of potential winning rows
    def draw?
      @cells.select(&:vacant?).size == 0
    end

    def print_board
      puts "\n\n"
      for i in -1...@rows_size
        for j in -1...@cols_size
          if i < 0 || j < 0
            if i < 0 && j < 0
              print green(".\t")
            elsif i < 0
              print green("#{j}\t")
            else
              print green("#{i}\t")
            end
          else
            cell = cell_at(i, j)
            token = cell.token || '-'
            if @winner_row && @winner_row.include?(cell)
              print red(token + "\t")
            else
              print token + "\t"
            end
          end
        end
        puts
      end
      puts "\n\n"
    end

    def green(text)
      "\033[32m#{text}\033[0m"
    end

    def red(text)
      "\033[31m#{text}\033[0m"
    end
  end
end
