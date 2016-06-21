require_relative 'spec_helper'

describe 'players strategy' do
  subject { NoughtsAndCrosses::Game.new(3, 3, 3) }
  let(:player_1) { NoughtsAndCrosses::Player::Human.new('x') }
  let(:player_2) { NoughtsAndCrosses::Player::AI::WinBlockOrOptimal.new('o') }

  before do
    subject.add_player(player_1)
    subject.add_player(player_2)
  end

  it "should find opponent's winning cell and block it" do
    x_moves = [[0, 2], [1, 2]]
    record_player_moves(subject, player_1, x_moves)

    cell = player_2.send(:blocking_cell)
    cell.row.must_equal 2
    cell.column.must_equal 2
    player_2.next_cell.must_equal cell
  end

  it 'should try block potential fork' do
    record_player_moves(subject, player_1, [[0, 1], [1, 2]])
    record_player_moves(subject, player_2, [[1, 1]])

    cell = player_2.next_cell
    cell.row.must_equal 0
    cell.column.must_equal 2
  end

  it 'should chose optimal cell by weight if no potential fork detected' do
    record_player_moves(subject, player_1, [[0, 1]])
    cell = player_2.next_cell
    cell.row.must_equal 1
    cell.column.must_equal 1
  end

  it 'should block winning streaks correctly in 10x10x5 game' do
    board = NoughtsAndCrosses::Game.new(10, 10, 5)
    board.add_player(player_1)
    board.add_player(player_2)

    record_player_moves(board, player_1, [[3, 3], [3, 4], [3, 5], [3, 6], [2, 5], [4, 6], [2, 6]])
    record_player_moves(board, player_2, [[4, 4], [3, 1], [3, 2], [3, 7], [4, 3], [2, 4]])

    cell = player_2.next_cell
    [cell.row, cell.column].must_equal [1, 6]
  end
end

def record_player_moves(game, player, moves = [])
  moves.each do |cell|
    game.occupy(game.cell_at(cell[0], cell[1]), player.token)
  end
end
