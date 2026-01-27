#!/usr/bin/env ruby

# DIAL WITH ARROW
#
# We parse the input, which looks like this:
#
# L68
# L30
# R48
# L5
#
# and as we read each line we keep a track of the position of the
# pointer, modulo 100. If it lands on zero, increment the counter.
#
# ./part1.rb tiny.txt
# ./part1.rb input.txt

class Puzzle
  def initialize(start)
    position = start
    @passwd = 0

    ARGF.each_line(chomp: true).each do |line|
      direction = line[0]
      instruction = line[1..].to_i
      case direction
      when 'L'
        position = (position - instruction).modulo(100)
      when 'R'
        position = (position + instruction).modulo(100)
      else
        abort('Invalid input')
      end
      @passwd += 1 if position.zero?
    end
  end

  def solve
    puts "Password: #{@passwd}"
  end
end

Puzzle.new(50).solve
