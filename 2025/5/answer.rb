#!/usr/bin/env ruby

# FRESH INGREDIENT ID RANGES
#
# We are given an input of two halves separated by a blank line
#
# 3-5
# 10-14
# 16-20
# 12-18
#
# 1
# 5
# 8
# 11
# 17
# 32
#
# The first half is a set of ingredient ranges, the second a
# list of ingredients.
# In part 1 we are asked to count ingredients that fall within the ranges.
# In part 2 we are asked how many items are within all the ranges,
# given that some of the ranges overlap.

class Puzzle
  class InvManager
    def initialize
      @ranges = []
      @ingredients = []
      ingest_input
    end

    def show
      puts "Ranges: #{@ranges}"
      puts "Ingredients: #{@ingredients}"
    end

    def in_a_range?(x)
      @ranges.each { return true if it.include?(x) }
      false
    end

    def count_fresh
      acc = 0
      @ingredients.each do |i|
        acc += 1 if in_a_range?(i)
      end
      acc
    end

    def merge_ranges(a, b)
      Range.new([a.begin, b.begin].min, [a.end, b.end].max)
    end

    # For each range in ranges, test it against the other ranges.
    # If it overlaps, merge the two and put the merged range in a compacted_ranges
    # Otherwise put it in compacted_ranges
    #
    # Repeat until no more merges occur
    def compact_ranges!
      compacted_ranges = []
      global_change_flag = false
      loop do
        x = @ranges.pop
        at_least_one_merge = false
        @ranges.each do |r|
          next unless r.overlap?(x)

          compacted_ranges << merge_ranges(r, x)
          at_least_one_merge = true
          global_change_flag = true
        end
        compacted_ranges << x unless at_least_one_merge
        break if @ranges.empty?
      end
      @ranges = compacted_ranges.uniq
      global_change_flag
    end

    def count_range_elements
      acc = 0
      @ranges.each do |r|
        acc += r.size
      end
      acc
    end

    private

    def ingest_input
      reading_ranges = true
      ARGF.each_line(chomp: true) do |line|
        if line == ''
          reading_ranges = false
          next
        end

        if reading_ranges
          r_a = line.split('-')
          @ranges << Range.new(r_a.first.to_i, r_a.last.to_i)
        else
          @ingredients << line.to_i
        end
      end
    end
  end

  def part1
    @inv_mgr = InvManager.new
    puts "Part 1: #{@inv_mgr.count_fresh}"
  end

  def part2
    loop do
      break unless @inv_mgr.compact_ranges!
    end
    puts "Part 2: #{@inv_mgr.count_range_elements}"
  end
end

p = Puzzle.new
p.part1
p.part2
