require_relative 'noughts_and_crosses.rb'

game = NoughtsAndCrosses::Game.new(3, 3, 3)

player_noughts = NoughtsAndCrosses::Player::AI::WinBlockOrOptimal.new('o')
player_crosses = NoughtsAndCrosses::Player::Human.new('x')

game.add_player(player_noughts)
game.add_player(player_crosses)

game.start
