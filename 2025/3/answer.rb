#!/usr/bin/env ruby

# JOLTAGE
#
# The input is a list of digit strings:
#
# 44265465554335...4354153538454225332755435544545533324152
# 43252824474224...3254243232342322553322244341312543932333
# 43323334423345...4444344242333247233254353342732444654333
#
# Within each string we are asked to find pairs that sum to a maximum value.
# In part 2 we find groups of 12 digits that make the largest number.
#
# To make the largest 2 digit, or 12 digit number we look for the
# largest digit in positions that leave enough left of the string to
# fill the remaing digit or 11 digits, then repeat the process for the
# remaining digits. We discard (drop) digits to the left of the max
# digit as we go.

# ./answer.rb tiny.txt
# ./answer.rb input.txt

def joltage(acc, remaining_digits, cells)
  return acc.to_i if remaining_digits.negative?

  sample_set = cells.take(cells.size - remaining_digits)
  digit = sample_set.max

  digit_index = sample_set.index(digit) + 1
  joltage(acc + digit, remaining_digits - 1, cells.drop(digit_index))
end

part_1 = 0
part_2 = 0
ARGF.each_line(chomp: true) do |battery_bank|
  part_1 += joltage('', 1, battery_bank.chars)
  part_2 += joltage('', 11, battery_bank.chars)
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
