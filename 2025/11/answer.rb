#!/usr/bin/env ruby

# PATHS THROUGH THE SERVER RACK
#
# Each line of the input as a labels followed by a colon and a list of labels:
#  aaa: you hhh
#  you: bbb ccc
#  bbb: ddd eee
#  ccc: ddd eee fff
#  ddd: ggg
#  eee: out
#  fff: out
#  ggg: out
#  hhh: ccc fff iii
#  iii: out
#
# These are server names and the other servers they are connected to.
# In part 1 we are asked to start at "you" and count the number of paths to "out".
# In part 2 we are asked to count the number of paths passing through dac and fft.
#
# Part 1 is a sinple recursive descent.
#
# Just counting paths for part 2 gives a combinatorial explosion. The
# insight needed is that we can count paths from:
#        svr to dac
#        dac to fft
#        fft to out
# and...
#        svr to fft
#        fft to dac
#        dac to out
#
# We then just add the two. We still need memoisation to cope with the
# depth of recursion.

class Puzzle
  def initialize
    @servers = {}
    @memo = {}
    ARGF
      .each_line(chomp: true)
      .map { |l| l.scan(/\A([a-z]+): ([a-z ]+)+\Z/).pop }
      .map { |key, vals| @servers[key.to_sym] = vals&.split&.map(&:to_sym) }
  end

  def solve_part1(x)
    return 1 if x == :out

    @servers[x].map { |k| solve_part1(k) }.flatten.reduce(:+)
  end

  def part1
    puts "Part 1: #{solve_part1(:you)}"
  end

  def count_paths(curr, target)
    return @memo[curr][target] if @memo[curr] && @memo[curr][target]

    return 1 if curr == target
    return 0 if curr == :out

    val = @servers[curr].map { |s| count_paths(s, target) }.reduce(:+)

    @memo[curr] = {} if @memo[curr].nil?
    @memo[curr][target] = val
    val
  end

  def part2
    p1 = count_paths(:svr, :dac) * count_paths(:dac, :fft) * count_paths(:fft, :out)
    p2 = count_paths(:svr, :fft) * count_paths(:fft, :dac) * count_paths(:dac, :out)
    puts "Part 2: #{p1 + p2}"
  end
end

p = Puzzle.new
p.part1
p.part2
