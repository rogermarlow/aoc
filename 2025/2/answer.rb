#!/usr/bin/env ruby

# PRODUCT ID RANGES
#
# The input is a list of ID pairs:
#
# 11-22,95-115,998-1012,1188511880-1188511890,...
#
# We are asked to find IDs in the ranges which consist of repeated
# digit strings. Part 1 is about repeating twice, part two any number
# of repeats.
#
# We use a regexp with group capture:
#   \A   Start of string
#   (.+) at least one character, referred to as group "1"
#   \1   group "1" repeated (\1+ repeated at least once)
#   \Z   End of string
#
# For all the IDs meeting the criteria, sum them in accumulators.
#
# ./answer.rb tiny.txt
# ./answer.rb input.txt

part1_acc1 = 0
part2_acc2 = 0

ARGF.read.scan(/(\d+)-(\d+)/) do |left, right|
  left.to_i.upto(right.to_i) do |id_num|
    part1_acc1 += id_num if /\A(.+)\1\Z/ =~ id_num.to_s
    part2_acc2 += id_num if /\A(.+)\1+\Z/ =~ id_num.to_s
  end
end

puts "Part1: #{part1_acc1}"
puts "Part2: #{part2_acc2}"
