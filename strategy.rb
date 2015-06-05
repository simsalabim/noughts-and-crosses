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
      rows.last.select(&:vacant?).max_by(&:weight) if rows.any?
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
