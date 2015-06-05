require 'minitest/autorun'

require_relative '../noughts_and_crosses'

describe 'Noughts And Crosses' do
  let(:rows_size) { 3 }
  let(:columns_size) { 3 }

  it 'should generate correct amount of cells' do
    game = NoughtsAndCrosses::Game.new(rows_size, columns_size, 3)
    game.instance_variable_get(:@cells).size.must_equal rows_size * columns_size
  end
end
