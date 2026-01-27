#!/usr/bin/env ruby
#
# In part 2 of the puzzle we are asked to count
# the number of possible paths. This is a straight forward
# recursion but because of the number of combinations we
# need to memoise the counter function.
#
# .......S.......         7
# .......|.......         7
# ......|^|......        6,8
# ......|.|......        6,8
# .....|^|^|.....       5,7,9
# .....|.|.|.....       5,7,9
# ....|^|^|^|....      4,6,8,10
# ....|.|.|.|....      4,6,8,10
# ...|^|^|||^|...     3,5,7,8,9,11
# ...|.|.|||.|...     3,5,7,8,9,11
# ..|^|^|||^|^|..    2,4,6,7,8,10,12
# ..|.|.|||.|.|..    2,4,6,7,8,10,12
# .|^|||^||.||^|.   1,3,4,5,7,8,10,11,13
# .|.|||.||.||.|.   1,3,4,5,7,8,10,11,13
# |^|^|^|^|^|||^|  0,2,4,6,8,10,11,12,14
# |.|.|.|.|.|||.|  0,2,4,6,8,10,11,12,14
#
#
# .......S.......    pb(0, 7) =
# .......|.......    pb(1, 7) =
# ......|^|......    pb(2,6) + pb(2,8) =
# ......|.|......    pb(3,6) + pb(3,8) =
# .....|^|^|.....    pb(4,5) + pb(4,7) + pb(4,9) =
# .....|.|.|.....    pb(5,5) + pb(5,7) + pb(5,9)

class Puzzle
  class QuantumTachyonManifold
    def initialize
      @rows = []
      ARGF.each_line(chomp: true) { @rows << it.chars }
      @bottom_limit = @rows.size - 1
      @right_limit = @rows[0].size - 1
      @beam_entry_col = @rows[0].index('S')
      @memo_cache = Array.new(@bottom_limit + 1, nil)
      0.upto(@bottom_limit) { @memo_cache[it] = Array.new(@right_limit + 1, nil) }
    end

    def count_paths_below(row, col)
      return @memo_cache[row][col] if @memo_cache[row][col]
      return 1 if row == @bottom_limit

      value = if beam_splits_on_next_row?(row, col)
                count_paths_below(row + 1, [0, col - 1].max) \
                        + count_paths_below(row + 1, [@right_limit, col + 1].min)
              else
                count_paths_below(row + 1, col)
              end

      @memo_cache[row][col] = value
      value
    end

    def count_timelines
      count_paths_below(0, @beam_entry_col)
    end

    private

    def beam_splits_on_next_row?(row, col)
      row != @bottom_limit && @rows[row + 1][col] == '^'
    end
  end

  def part2
    q = QuantumTachyonManifold.new
    puts "Part 2: #{q.count_timelines}"
  end
end

Puzzle.new.part2
