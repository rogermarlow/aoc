#!/usr/bin/env ruby

#
# RECTANGLES
#
# The input is a list of coordinates of tiles in a grid:
# 7,1
# 11,1
# 11,7
# 9,7
# 9,5
# 2,5
# 2,3
# 7,3
#
# These are imagined to be coordinates of red tiles in a bigger grid
# of tiles:
#
# ..............
# .......#...#..
# ..............
# ..#....#......
# ..............
# ..#......#....
# ..............
# .........#.#..
# ..............
#
# Rectangles are formed by choosing two red tiles as opposite corners.
# We model points as pairs of integers. We model rectangles as two
# ranges of integers on the X and Y axes. We can construct Rectangles
# with either ranges or a pair of points representing opposite
# corners.
#
# In part 1 we are asked to find the largest rectangle.
#
# In part 2 the red tiles are connected horizontally and vertically by
# green tiles, forming a perimeter of green and red tiles. The area
# enclosed by that perimeter is filled with green tiles. We are asked
# to find the largest rectangle which contains only red or only green
# tiles.
#
# The necessary insights are:
#  1. We operate on an integer grid
#  2a. Lines connecting corners are rectangles of width or height 1
#  2b. The permimeter can be considered as a list of rectangles
#  3. A rectangle stripped of its perimeter has an "inner" rectangle
#  4. Rectangles intersect if their inner rectangles overlap
#  5. A rectangle formed from points on the perimeter will contain only
#     green tiles if its inner does not intersect with the perimeter
#
#  Because @rectangles is sorted largest area first, we just have to find
#  the first rectangle with no overlaps with the permimeter.

# Point modelled as a pair of integers
class Point2D
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end
end

class Puzzle
  # A Rectangle on an integer spaced grid.
  # It can be created as a ranges along the x and y axes
  # or with either opposite corners as Point2Ds
  class Rectangle
    attr_reader :x_range, :y_range

    def initialize(a, b)
      if a.is_a? Range
        @x_range = a
        @y_range = b
      elsif a.is_a? Point2D
        @x_range = ([a.x, b.x].min..[a.x, b.x].max)
        @y_range = ([a.y, b.y].min..[a.y, b.y].max)
      end
    end

    def area = @x_range.size * @y_range.size

    def overlaps?(other)
      x_range.overlap?(other.x_range) && y_range.overlap?(other.y_range)
    end

    # A new rectangle formed by removing the edge of the current rectangle
    def inner
      Rectangle.new((x_range.first + 1)...x_range.last,
                    (y_range.first + 1)...y_range.last)
    end
  end

  def initialize
    @points = ARGF.each_line(chomp: true).map do |l|
      Point2D.new(*l.split(',').map(&:to_i))
    end

    @rectangles = @points.combination(2)
                         .map { |p1, p2| Rectangle.new(p1, p2) }
                         .sort_by { |r| -r.area }
  end

  def part1
    @rectangles.first.area
  end

  def part2
    lines = (@points + [@points.first])
            .each_cons(2)
            .map { |(left, right)| Rectangle.new(left, right) }
    @rectangles.find do |rectangle|
      inner = rectangle.inner
      lines.none? { |line| line.overlaps?(inner) }
    end.area
  end
end

puzzle = Puzzle.new
puts "Part 1: #{puzzle.part1}"
puts "Part 2: #{puzzle.part2}"
