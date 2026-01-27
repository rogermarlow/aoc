#!/usr/bin/env ruby

# REMOVING ROLLS FROM A 2D GRID
#
# The input is a map of locations of rolls on a grid:
# ..@@.@@@@.
# @@@.@.@.@@
# @@@@@.@.@@
# @.@@@@..@.
#
# In part 1 we are asked to find rolls with fewer than four
# neighbours. The approach is to model a 2D grid which we can access
# by (x,y) coordinates. We build on that functions to count occupancy
# of neighbouring cells, with utilities to handle edges.
#
# In part 2 we are asked to remove the rolls meeting the part 1
# criteria then re-count, until there are no more removable rolls.
#
# A Diagram of the rolls is modelled as a 2D array, origin (0,0) at
# the top left.
#
#  left    right
#        X
#      012345
#    0 @.@@.@  upper
# Y  1 ..@@.@
#    2 ...@@@  lower
#    :
#
# ./answer.rb tiny.txt
# ./answer.rb input.txt

class Puzzle
  class Diagram
    def initialize
      @grid = []
      ARGF.each_line(chomp: true) { @grid << it.chars }
      @y_max_index = @grid.size - 1
      @x_max_index = @grid[0].size - 1
    end

    def show = @grid.each { puts it.join(' ') }

    def count_accessible_rolls
      qualifiers = 0
      0.upto(@x_max_index).each do |x|
        0.upto(@y_max_index).each do |y|
          qualifiers += 1 if roll_is_accessible?(x, y)
        end
      end
      qualifiers
    end

    def remove_accessible_rolls
      coords_of_accessible_rolls.each { remove_roll(it[0], it[1]) }
    end

    private

    def occupied?(x, y) = @grid[y][x] == '@'
    def remove_roll(x, y) = @grid[y][x] = 'x'
    # Given a potentially negative index bound it at the relevant edge.
    def left_bound(x)  = [0, x].max
    def right_bound(x) = [x, @x_max_index].min
    def upper_bound(y) = [0, y].max
    def lower_bound(y) = [y, @y_max_index].min

    def coords_of_accessible_rolls
      qualifiers = []
      0.upto(@x_max_index).each do |x|
        0.upto(@y_max_index).each do |y|
          qualifiers << [x, y] if roll_is_accessible?(x, y)
        end
      end
      qualifiers
    end

    def roll_is_accessible?(x, y)
      return false unless occupied?(x, y)

      count_occupied_neighbours(x, y) < 4
    end

    def count_occupied_neighbours(x, y)
      neighbours = 0
      left_bound(x - 1).upto(right_bound(x + 1)).each do |i|
        upper_bound(y - 1).upto(lower_bound(y + 1)).each do |j|
          next if i == x && j == y

          neighbours += 1 if occupied?(i, j)
        end
      end
      neighbours
    end
  end

  def part1
    @diagram = Diagram.new
    puts "Part 1: #{@diagram.count_accessible_rolls}"
  end

  def part2
    acc = 0
    loop do
      removable = @diagram.count_accessible_rolls
      break if removable.zero?

      acc += removable
      @diagram.remove_accessible_rolls
    end
    puts "Part 2: #{acc}"
  end
end

p = Puzzle.new
p.part1
p.part2
