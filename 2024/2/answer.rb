#!/usr/bin/env ruby

class Puzzle
  def initialize
    @reports = []
    ARGF.readlines(chomp: true).each do |line|
      @reports << line.split.map(&:to_i)
    end
  end

  def part1
    puts "#{@reports.count { |r| safe?(r) }} reports are safe."
  end

  def part2
    puts "#{@reports.count { |r| safe_with_dampener?(r) }} reports are safe with the dampener."
  end

  private

  def safe?(report)
    safe_range?(report) && safe_gradient?(report)
  end

  def safe_with_dampener?(report)
    (safe_range?(report) && safe_gradient?(report)) || subsequences(report).any? { |r| safe?(r) }
  end

  def safe_range?(report)
    report.each_cons(2).all? { |p| [1, 2, 3].include? (p[0] - p[1]).abs }
  end

  def safe_gradient?(report)
    report.each_cons(2).all? { |p| p[0] > p[1] } || report.each_cons(2).all? { |p| p[0] < p[1] }
  end

  def subsequences(arr)
    arr.each_index.map { |i| arr[0...i] + arr[(i + 1)..] }
  end
end

p = Puzzle.new
p.part1
p.part2
