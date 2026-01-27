#!/usr/bin/env ruby

index = 0
counter = 0
ARGF.each_line(chmop: true) do |line|
  index += 1
  next if index <= 30

  # 47x47: 38 32 39 37 41 38
  pieces = line
           .scan(/\A(\d{2})x(\d{2}):\s(\d{2})\s(\d{2})\s(\d{2})\s(\d{2})\s(\d{2})\s(\d{2})\Z/)
           .pop           # Scan returns an array within an array
           .map(&:to_i)   # Strings to numbers
           .reverse       # Get ready for pop which works from the end

  region = pieces.pop * pieces.pop
  num_pieces_to_fit = pieces.reduce(:+)
  counter += 1 if region > 8 * num_pieces_to_fit
end

puts counter
