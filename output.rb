module NoughtsAndCrosses
  module Output
    def print_board
      puts "\n\n"
      for i in -1...@rows_size
        for j in -1...@cols_size
          if i < 0 || j < 0
            print_axes(i, j)
          else
            print_cell(i, j)
          end
        end
        puts
      end
      puts "\n\n"
    end

    def print_axes(row, column)
      if row < 0 && column < 0
        print green(".\t")
      elsif row < 0
        print green("#{column}\t")
      else
        print green("#{row}\t")
      end
    end

    def print_cell(row, column)
      cell = cell_at(row, column)
      token = cell.token || '-'
      if @winner_row && @winner_row.include?(cell)
        print red(token + "\t")
      else
        print token + "\t"
      end
    end

    def green(text)
      "\033[32m#{text}\033[0m"
    end

    def red(text)
      "\033[31m#{text}\033[0m"
    end
  end
end
