# Noughts And Crosses 
![Build Status] (https://travis-ci.org/simsalabim/noughts-and-crosses.svg?branch=master "Build Status") [![Code Climate](https://codeclimate.com/github/simsalabim/noughts-and-crosses/badges/gpa.svg?refresh=1)](https://codeclimate.com/github/simsalabim/noughts-and-crosses)

A simple console (M, N, W) game written in Ruby.

## How to play
To play simple (3, 3, 3) game aka Tic-Tac-Toe against "experienced" AI, run the following from your console: `ruby launcher.rb`

Customizing options:

```
Usage: launcher.rb [options]
    -c, --board-width=value          Board width in columns [integer]
    -r, --board-height=value         Board height in rows [integer]
    -w, --winning-streak=value       Winning streak [integer]
    -x, --player-x=value             Player who plays X [human, expert or novice]
    -o, --player-o=value             Player who plays O [human, expert or novice]
```

E.g.: the following will let you watch two bots playing larger game: ` ruby launcher.rb -r 5 -c 5 -w 5 -x expert -o novice`

Warning: games with boards larger than 3x3 will be challenging for humans to play from UI perspective :)
## Tests
```
rake
```

## TODO
- Teach bots play W < N (W < M) games like 10x10x5 and detect potential loss better (3 in row w/ 3 vacant surrounding
cells).
- Teach bots play non-square games, e.g. 10x6x4
