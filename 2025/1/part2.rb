#!/usr/bin/env ruby

# ANY CLICK CAUSES THE DIAL TO POINT TO 0
#
# Unlike part 1 where we take the whole instruction and just mod 100
# here we simulate every click to see if it lands on zero.
#
# ./part2.rb tiny.txt
# ./part2.rb input.txt

class Puzzle
  def initialize(start)
    position = start
    @pass_zero_counter = 0

    ARGF.each_line(chomp: true).each do |line|
      direction = line[0]
      instruction = line[1..].to_i
      loop do
        case direction
        when 'L'
          position = (position - 1) % 100
        when 'R'
          position = (position + 1) % 100
        end
        @pass_zero_counter += 1 if position.zero?

        instruction -= 1
        break if instruction.zero?
      end
    end
  end

  def solve
    puts "Final password: #{@pass_zero_counter}"
  end
end

Puzzle.new(50).solve
