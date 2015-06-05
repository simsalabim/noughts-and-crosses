module NoughtsAndCrosses
  module Player
    module AI
      class Random < Base
        include Strategy

        def next_cell
          random_cell
        end
      end
    end
  end
end
