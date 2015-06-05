module NoughtsAndCrosses
  module Player
    class Human < Base
      def next_cell
        puts ' > your move: input number of row and column separated by space'
        row, column = gets.split(' ').map(&:to_i)
        cell = @game.cell_at(row, column)
        until cell.vacant?
          puts '\nYou should choose another cell'
          row, column = gets.split(' ').map(&:to_i)
          cell = @game.cell_at(row, column)
        end
        cell
      end
    end
  end
end
