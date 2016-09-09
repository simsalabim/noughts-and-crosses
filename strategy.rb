module NoughtsAndCrosses
  module Strategy
    private

    def winning_cell
      row = @game.almost_won_row(@token)
      if row
        occupied_cell = row.find { |c| c.token == @token }
        index = row.index(occupied_cell)
        if index - 1 >= 0 && row[index - 1].token.nil?
          row[index - 1]
        else
          row.reverse!
          occupied_cell = row.find { |c| c.token == @token }
          index = row.index(occupied_cell)
          row[index - 1] if index - 1 >= 0 && row[index - 1].token.nil?
        end
      end
    end

    def blocking_cell
      row = @game.almost_lost_row(@token)

      if row
        return row.find(&:vacant?) if row.select { |c| c.vacant? }.size == 1
        occupied_by_opponent = row.find { |c| c.token != nil && c.token != @token }
        index = row.index(occupied_by_opponent)
        if index - 1 >= 0 && row[index - 1].token.nil?
          row[index - 1]
        else
          row.reverse!
          occupied_by_opponent = row.find { |c| c.token != nil && c.token != @token }
          index = row.index(occupied_by_opponent)
          row[index - 1] if index - 1 >= 0 && row[index - 1].token.nil?
        end
      else
        if @game.winning_row_size < @game.rows_size || @game.winning_row_size < @game.cols_size
          blocking_fork_cell(:predictive)
        else
          blocking_fork_cell
        end
      end
    end

    def optimal_cell
      return unless weighed_win_rows.any?
      weighed_win_rows.last.select(&:vacant?).max_by(&:weight)
    end

    def blocking_fork_cell(mode = nil)
      (@game.tokens - [@token]).each do |opponent|
        vacant_cells = []
        rows_occupied_by(opponent).each do |row|
          vacant_cells << row.select(&:vacant?)
        end

        if mode == :predictive
          vacant_cells.flatten.each do |cell|
            @game.occupy(cell, opponent)
            potential_wins_count = @game.almost_won_rows(opponent).size
            @game.vacate(cell)
            return cell if potential_wins_count > 1
          end
        else
          vacant_cells.flatten.each do |cell|
            potential_wins_count = @game.almost_won_rows(opponent).size
            return cell if potential_wins_count == 1
          end
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
