require_relative 'spec_helper'

describe 'initial game setup' do
  let(:rows_size) { 4 }
  let(:columns_size) { 3 }
  subject { NoughtsAndCrosses::Game.new(rows_size, columns_size, 3) }

  it 'should generate correct amount of cells' do
    subject.board_cells.size.must_equal rows_size * columns_size
  end

  it 'should generate correct amount of rows' do
    subject.board.size.must_equal rows_size
  end

  it 'should generate correct amount of columns' do
    subject.board[0].size.must_equal columns_size
  end
end
