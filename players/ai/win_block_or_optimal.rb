module NoughtsAndCrosses
  module Player
    module AI
      class WinBlockOrOptimal < Base
        include Strategy

        def next_cell
          winning_cell || blocking_cell || optimal_cell || random_cell
        end
      end
    end
  end
end
