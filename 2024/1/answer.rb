#!/usr/bin/env ruby

class Puzzle
  def initialize
    @left = []
    @right = []
    ARGF.read.scan(/(\d+)\s+(\d+)/).each do |l, r|
      @left << l.to_i
      @right << r.to_i
    end
  end

  def part1
    @left.sort!
    @right.sort!
    distances = @left.zip(@right).map { |l, r| (l - r).abs }
    puts "Sum of distances: #{distances.sum}"
  end

  def part2
    occurances = {}
    @left.each do |e|
      occurances[e] ||= @right.count(e)
    end
    similarity_score = 0
    @left.each do |e|
      similarity_score += e * occurances[e]
    end
    puts "Similarity score = #{similarity_score}"
  end
end

p = Puzzle.new
p.part1
p.part2
