module NoughtsAndCrosses
  class Cell
    attr_accessor :token
    attr_reader :row, :column, :weight

    def initialize(row, column)
      @row = row
      @column = column
      @token = nil
      @weight = 0
    end

    def vacant?
      @token.nil?
    end

    def increment_weight
      @weight += 1
    end
  end
end
