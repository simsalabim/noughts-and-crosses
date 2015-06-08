require 'minitest/autorun'

require_relative '../noughts_and_crosses'

describe 'Noughts And Crosses' do
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

  describe 'game state' do
    subject { NoughtsAndCrosses::Game.new(4, 4, 2) }
    let(:player_1) { NoughtsAndCrosses::Player::Human.new('x') }
    let(:player_2) { NoughtsAndCrosses::Player::Human.new('o') }

    before do
      subject.add_player(player_1)
      subject.add_player(player_2)
    end

    describe 'draw' do
      subject { NoughtsAndCrosses::Game.new(3, 3, 4) }

      it 'draw' do
        x_moves = [[0, 0], [0, 1], [0, 2], [2, 0], [2, 1]]
        o_moves = [[1, 0], [1, 1], [1, 2], [2, 2]]

        record_player_moves(subject, player_1, x_moves)
        record_player_moves(subject, player_2, o_moves)

        subject.draw?.must_equal true
      end
    end

    describe 'winning state' do
      it 'should report win if player has W tokens in row placed horizontally' do
        winner_row = [[0, 0], [0, 1]]
        record_player_moves(subject, player_1, winner_row)
        subject.game_over?.must_equal true
        subject.winner_row.map { |c| [c.row, c.column] }.must_equal winner_row
      end

      it 'should report win if player has W tokens in row placed vertically' do
        winner_row = [[0, 0], [1, 0]]
        record_player_moves(subject, player_1, winner_row)
        subject.game_over?.must_equal true
        subject.winner_row.map { |c| [c.row, c.column] }.must_equal winner_row
      end

      it 'should report win if player has W tokens in row placed in diagonal' do
        winner_row = [[0,2], [1, 3]]
        record_player_moves(subject, player_1, winner_row)
        subject.game_over?.must_equal true
        subject.winner_row.map { |c| [c.row, c.column] }.must_equal winner_row
      end
    end

    describe "players strategy" do
      subject { NoughtsAndCrosses::Game.new(3, 3, 3) }
      let(:player_2) { NoughtsAndCrosses::Player::AI::WinBlockOrOptimal.new('o') }

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
    end
  end
end

def record_player_moves(game, player, moves = [])
  moves.each do |cell|
    game.occupy(game.cell_at(cell[0], cell[1]), player.token)
  end
end
