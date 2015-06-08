module NoughtsAndCrosses
  module Strategy
    private

    def winning_cell
      row = @game.almost_won_row(@token)
      row.find(&:vacant?) if row
    end

    def blocking_cell
      row = @game.almost_lost_row(@token)
      row.find(&:vacant?) if row
    end

    def optimal_cell
      rows = weighed_win_rows
      return unless rows.any?

      vacant_cells = rows.last.select(&:vacant?)
      leaders = {}
      vacant_cells.each { |cell| leaders[cell] = 0 }

      (@game.tokens - [@token]).each do |opponent|
        opponent_occupied_rows = @game.available_win_rows(opponent).reject { |r| r.all?(&:vacant?) }

        opponent_occupied_rows.each do |row|
          vacant_cells.each do |cell|
            leaders[cell] += 1 if row.include? cell
          end
        end
      end
      blocking_fork = leaders.sort_by { |_, value| value }.last[0]
      blocking_fork || rows.last.select(&:vacant?).max_by(&:weight)
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
