require_relative 'noughts_and_crosses.rb'
require 'optparse'

PLAYERS = {
  human:  NoughtsAndCrosses::Player::Human,
  expert: NoughtsAndCrosses::Player::AI::WinBlockOrOptimal,
  novice: NoughtsAndCrosses::Player::AI::Random
}
options = {
  board: {
    rows: 3,
    column: 3,
    winning_streak: 3
  },
  players: {
    x: PLAYERS[:expert],
    o: PLAYERS[:human]
  }
}

OptionParser.new do |opts|
  opts.banner = "Usage: launcher.rb [options]"

  opts.on('-c=value', '--board-width=value', 'Board width in columns [integer]') do |w|
    options[:board][:columns] = w.to_i
  end

  opts.on('-r=value', '--board-height=value', 'Board height in rows [integer]') do |h|
    options[:board][:rows] = h.to_i
  end

  opts.on('-w=value', '--winning-streak=value', 'Winning streak [integer]') do |w|
    options[:board][:winning_streak] = w.to_i
  end

  opts.on('-x=value', '--player-x=value', 'Player who plays X [human, expert or novice]') do |x|
    options[:players][:x] = PLAYERS[x.to_sym]
  end

  opts.on('-o=value', '--player-o=value', 'Player who plays O [human, expert or novice]') do |o|
    options[:players][:o] = PLAYERS[o.to_sym]
  end
end.parse!


game = NoughtsAndCrosses::Game.new(options[:board][:rows], options[:board][:columns], options[:board][:winning_streak])

player_noughts = options[:players][:o].new('o')
player_crosses = options[:players][:x].new('x')

game.add_player(player_noughts)
game.add_player(player_crosses)

game.start
