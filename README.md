# Noughts And Crosses

A simple console (M, N, W) game written in Ruby.

## How to play
To play simple (3, 3, 3) game aka Tic-Tac-Toe against "experienced" AI, run the following from your console:
```shell
ruby launcher.rb

```
Edit `launcher.rb` to watch bots playing or play in "hot seat" mode.
Warning: games with boards larger than 3x3 will be challenging to play from UI perspective :)

## TODO
- Teach bots play W < N (W < M) games like 10x10x5 and detect potential loss better (3 in row w/ 3 vacant surrounding
cells).
- Teach bots play non-square games, e.g. 10x6x4
- CLI with optparse
