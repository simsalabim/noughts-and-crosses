module NoughtsAndCrosses
  module BoardBuilder
    def generate_board
      board = []
      for i in 0...@rows_size
        row = []
        for j in 0...@cols_size
          row.push(Cell.new(i, j))
        end
        board.push(row)
      end
      board
    end

    def board_cells
      @board_cells ||= board.flatten
    end

    def horizontal_win_rows
      horizontal_or_vertical_win_rows(@rows_size, @cols_size, true)
    end

    def vertical_win_rows
      horizontal_or_vertical_win_rows(@cols_size, @rows_size, false)
    end

    def horizontal_or_vertical_win_rows(first_bound, second_bound, is_horizontal = true)
      rows = []
      for i in 0..first_bound
        for j in 0..(second_bound - @winning_row_size)
          jj = j
          row = []
          while jj < j + @winning_row_size
            if is_horizontal
              row.push(cell_at(i, jj))
            else
              row.push(cell_at(jj, i))
            end
            jj += 1
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
          row = detect_diagonal_row(i, j, 1)
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
          row = detect_diagonal_row(i, j, -1)
          rows.push(row) if row.any?
        end
        i -= 1
      end
      rows
    end

    def detect_diagonal_row(i, j, i_increment)
      row = []
      @winning_row_size.times do
        row.push(cell_at(i, j))
        i += i_increment
        j += 1
      end
      row
    end

    def cell_at(row, column)
      board_cells.find { |cell| cell.row == row && cell.column == column }
    end

    def vacant_cells
      board_cells.select(&:vacant?)
    end

    def occupy(cell, token)
      cell.token = token
    end
  end
end
