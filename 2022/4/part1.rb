#!/usr/bin/env ruby

tally = 0
ARGF.readlines(chomp: true).each do |line|
  first, second = line.split(',')
  s1, e1 = first.split('-')
  s2, e2 = second.split('-')
  tally += 1 if ((s1..e1).include?(s2) && (s1..e1).include?(e2)) || ((s2..e2).include?(s1) && (s2..e2).include?(e1))
end

puts "Part 1: #{tally}"
