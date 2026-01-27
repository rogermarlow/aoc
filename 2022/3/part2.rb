#!/usr/bin/env ruby

lower_case_base = 'a'.ord - 1
upper_case_base = 'A'.ord - 1

tally = 0
ARGF.each_slice(3) do |group|
  g1 = group[0].chars
  g2 = group[1].chars
  g3 = group[2].chars
  badge = g1.intersection(g2).intersection(g3)[0]
  priority = if ('a'..'z').include? badge
               badge.ord - lower_case_base
             elsif ('A'..'Z').include? badge
               badge.ord - upper_case_base + 26
             else
               abort "Bug on #{badge}"
             end
  tally += priority
end

puts "Part 2: #{tally}"
