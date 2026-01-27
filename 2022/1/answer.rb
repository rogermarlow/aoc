#!/usr/bin/env ruby

# CALORIE COUNTING
#
# ./answer.rb input.txt
class Puzzle
  def initialize
    @input = ARGF.readlines(chomp: true).map(&:to_i)
    @tally = {}
  end

  def part1
    elf = 1
    @input.each_with_object(@tally) do |cal, sum|
      if sum[elf].nil?
        sum[elf] = cal
      else
        sum[elf] += cal
      end
      elf += 1 if cal.zero?
    end

    answer = @tally.max_by { |_e, v| v }
    puts "Part 1: Elf #{answer[0]} with value #{answer[1]}"
  end

  def part2
    puts 'Part 2 - sum of top 3'
    puts @tally.sort_by { |_elf, calorie| calorie }.reverse[0..2].map(&:last).sum
  end
end

p = Puzzle.new
p.part1
p.part2
