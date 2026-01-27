#!/usr/bin/env ruby

# The input is a 2D map with an "entrance" at S.
#
# .......S.......
# ...............
# .......^.......
# ...............
# ......^.^......
# ...............
#
# We progress downwards line by line. If we encounter
# a splitter "^" we divide and progress either side
# of the splitter.
#
# Part 1 asks us to count the number of times we encounter a splitter.

class Puzzle
  class TachyonManifold
    attr_reader :split_counter

    def initialize
      @rows = ARGF.each_line(chomp: true).map(&:chars)
      @beam_row = 0
      @right_limit = @rows[0].size - 1
      @bottom_limit = @rows.size - 1
      @split_counter = 0
    end

    # Extend the beam at row,col down to row++
    def extend_beam_one_row(row, col)
      next_row = row + 1
      case @rows[next_row][col]
      when '.'
        @rows[next_row][col] = '|'
      when '|'
      # Already contains a beam
      when '^'
        @split_counter += 1
        # split left
        new_col = [col - 1, 0].max
        @rows[next_row][new_col] = '|'
        # split right
        new_col = [col + 1, @right_limit].min
        @rows[next_row][new_col] = '|'
      end
    end

    def extend_beams_in_row
      @rows[@beam_row].each_with_index do |c, i|
        extend_beam_one_row(@beam_row, i) if (c == '|') || (c == 'S')
      end
      @beam_row += 1
    end

    def show
      @rows.each do |row|
        row.each do |col|
          print col
        end
        $stdout.flush
        puts "\n"
      end
    end

    def run
      @bottom_limit.times do
        extend_beams_in_row
      end
      self # Support method chaining
    end
  end

  def part1
    TachyonManifold.new.run.split_counter
  end
end

puts "Part1: #{Puzzle.new.part1}"
