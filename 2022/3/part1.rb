#!/usr/bin/env ruby

tally = 0
ARGF.readlines(chomp: true).each do |line|
  contents = line
  mid = (contents.length / 2) - 1
  first_half = contents.chars[0..mid]
  second_half = contents.chars[(mid + 1)..contents.length]

  shared = first_half.intersection(second_half).first

  lower_case_base = 'a'.ord - 1
  upper_case_base = 'A'.ord - 1

  priority = 0
  if ('a'..'z').include? shared
    priority = shared.ord - lower_case_base
  elsif ('A'..'Z').include? shared
    priority = shared.ord - upper_case_base + 26
  else
    puts "Bug on #{shared}"
  end
  tally += priority
end

puts "Part 1: #{tally}"
