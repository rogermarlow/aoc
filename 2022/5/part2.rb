#!/usr/bin/env ruby

#            [C]         [N] [R]
# [J] [T]     [H]         [P] [L]
# [F] [S] [T] [B]         [M] [D]
# [C] [L] [J] [Z] [S]     [L] [B]
# [N] [Q] [G] [J] [J]     [F] [F] [R]
# [D] [V] [B] [L] [B] [Q] [D] [M] [T]
# [B] [Z] [Z] [T] [V] [S] [V] [S] [D]
# [W] [P] [P] [D] [G] [P] [B] [P] [V]
# 1   2   3   4   5   6   7   8   9

# move 4 from 9 to 6
# move 7 from 2 to 5

# Array: [ 'W', 'B', 'D', ... , 'J' ]
# 'W' is at the "bottom"
# 'J' is at the "top"
class Stack
  def initialize
    @stack = []
  end

  def place_on_stack(crate)
    @stack.push(crate)
  end

  def remove_from_stack
    @stack.pop
  end

  def reverse_stack
    @stack.reverse!
  end

  def remove_blanks
    @stack.reject! { |e| e == ' ' }
  end

  def remove_n_from_stack(n)
    @stack.pop(n)
  end

  def place_n_on_stack(n)
    @stack.push(n).flatten!
  end
end

stacks = {
  1 => Stack.new,
  2 => Stack.new,
  3 => Stack.new,
  4 => Stack.new,
  5 => Stack.new,
  6 => Stack.new,
  7 => Stack.new,
  8 => Stack.new,
  9 => Stack.new
}

# Read stacks from input
File.readlines('input.txt', chomp: true).each_with_index do |line, index|
  (1..9).each do |stack|
    stacks[stack].place_on_stack(line[(4 * (stack - 1)) + 1])
  end
  break if index == 8
end

(1..9).each do |stack|
  stacks[stack].reverse_stack
  stacks[stack].remove_blanks
end

# Execute moves
line_parser = /move\s+(?<num>\d+)\s+from\s+(?<from>\d+)\s+to\s+(?<to>\d+)$/

# ---- Part 2

File.readlines('input.txt', chomp: true).each_with_index do |line, index|
  # Discard first 10 rows
  next if index < 10

  parsed = line_parser.match(line)
  num  = parsed['num'].to_i
  from = parsed['from'].to_i
  to   = parsed['to'].to_i

  stacks[to].place_n_on_stack(stacks[from].remove_n_from_stack(num))
end

(1..9).each do |stack|
  puts "#{stack} : #{stacks[stack].remove_from_stack}"
end

# 1 : T
# 2 : P
# 3 : F
# 4 : F
# 5 : B
# 6 : D
# 7 : R
# 8 : J
# 9 : D
