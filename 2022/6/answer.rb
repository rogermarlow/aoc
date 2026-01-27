#!/usr/bin/env ruby

# Part 1

buffer = ARGF.read

puts "Buffer is #{buffer.size} characters."

# Start of packet...
(0..(buffer.size - 4)).each do |start|
  trial = buffer[start..(start + 3)]
  if trial.size == trial.chars.uniq.size
    puts "Packet starts at #{start + 4}"
    break
  end
end

# Start of message...
(0..(buffer.size - 14)).each do |start|
  trial = buffer[start..(start + 13)]
  if trial.size == trial.chars.uniq.size
    puts "Message starts at #{start + 14}"
    break
  end
end
