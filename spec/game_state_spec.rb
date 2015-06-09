require_relative 'spec_helper'

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
end
