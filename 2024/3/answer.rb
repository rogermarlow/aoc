#!/usr/bin/env ruby

class Puzzle
  def initialize
    @memory = ARGF.read.chomp
  end

  def part1
    puts "Part 1: #{eval_mul_stmts(@memory)}"
  end

  # Delete out the disabled sections of memory between don't and do,
  # Then fall back to the part 1 solution.
  # Regexp: Start with don't() then the shortest run of chars until either do() or end of input.
  DISABLED = /don't\(\).*?(do\(\)|\z)/m
  def part2
    puts "Part 2: #{eval_mul_stmts(@memory.gsub(DISABLED, ''))}"
  end

  private

  # Match against mul(a,b) with a and b captured.
  # Scan then returns all captured groups as an array.
  # "mul(2,3)mul(4,5)".scan(VALID_MULT_STMT) => [["2","3"],["4","5"]]
  VALID_MUL_STMT = /mul\((\d+),(\d+)\)/
  def eval_mul_stmts(m)
    m.scan(VALID_MUL_STMT).sum{|a,b| a.to_i * b.to_i}
  end
end

p = Puzzle.new
p.part1
p.part2
