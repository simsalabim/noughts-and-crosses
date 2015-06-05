module NoughtsAndCrosses
  module Player
    class Base
      attr_reader :token
      attr_writer :game

      def initialize(token)
        @token = token
      end

      def make_move
        cell = next_cell
        @game.occupy(cell, @token)
        cell
      end

      private

      def next_cell
        fail 'Must be implemented in child classes'
      end
    end
  end
end
