module NoughtsAndCrosses
  module Strategy
    private

    def winning_cell
      row = @game.almost_won_row(@token)
      row.find(&:vacant?) if row
    end

    def blocking_cell
      row = @game.almost_lost_row(@token)
      row ? row.find(&:vacant?) : blocking_fork_cell
    end

    def optimal_cell
      return unless weighed_win_rows.any?
      weighed_win_rows.last.select(&:vacant?).max_by(&:weight)
    end

    def blocking_fork_cell
      (@game.tokens - [@token]).each do |opponent|
        vacant_cells = []
        rows_occupied_by(opponent).each do |row|
          vacant_cells << row.select(&:vacant?)
        end

        vacant_cells.flatten.each do |cell|
          @game.occupy(cell, opponent)
          potential_wins_count = @game.almost_won_rows(opponent).size
          @game.vacate(cell)
          return cell if potential_wins_count > 1
        end
      end
      nil
    end

    def rows_occupied_by(token)
      @game.available_win_rows(token).reject { |row| row.all?(&:vacant?) }
    end

    def random_cell
      @game.vacant_cells.sample
    end

    def weighed_win_rows
      @game.available_win_rows(@token).sort_by do |row|
        [
          row.select { |cell| cell.token == @token }.size,
          row.inject(0) { |sum, cell| sum + cell.weight }
        ]
      end
    end
  end
end
