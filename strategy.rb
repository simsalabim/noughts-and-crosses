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
      return unless weighed_win_rows.any?

      blocking_fork = opponent_appearances.sort_by { |_, value| value }.last[0]
      blocking_fork || rows.last.select(&:vacant?).max_by(&:weight)
    end

    def opponent_appearances
      appearances = {}
      heaviest_vacant_cells.each { |cell| appearances[cell] = 0 }

      (@game.tokens - [@token]).each do |opponent|
        rows_occupied_by(opponent).each do |row|
          heaviest_vacant_cells.each do |cell|
            appearances[cell] += 1 if row.include? cell
          end
        end
      end
      appearances
    end

    def heaviest_vacant_cells
      @heaviest_vacant_cells ||= weighed_win_rows.last.select(&:vacant?)
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
