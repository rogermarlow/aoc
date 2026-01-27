#!/usr/bin/env ruby

# Day 2 Answer
#
# Rock beats scissors
# Scissors beats paper
# Paper beats rock
#
# Opponent: A = Rock, B = Paper, C = Scissors
# Me      : X = Rock, Y = Paper, Z = Scissors
#
# Score
# Rock = 1, 2 = Paper, 3 = Scissors
# Outcome: 0 loss, 3 draw, 6 win
#
#
#
# A Y = Rock / Paper / Win , Score 2 + 6 = 8
# B Y = opponent Paper, me Paper, draw. Score 2 + 3 = 5

WIN  = 6
DRAW = 3
LOSS = 0

def parse(play)
  case play
  when 'A', 'X'
    :rock
  when 'B', 'Y'
    :paper
  when 'C', 'Z'
    :scissors
  else
    abort "Invalid input #{play}"
  end
end

def determine_round(oppo, me)
  score = 0
  case oppo
  when :rock
    case me
    when :rock
      score = DRAW
    when :paper
      score = WIN
    when :scissors
      score = LOSS
    else
      abort 'Bug 1'
    end
  when :paper
    case me
    when :rock
      score = LOSS
    when :paper
      score = DRAW
    when :scissors
      score = WIN
    else
      abort 'Bug 2'
    end
  when :scissors
    case me
    when :rock
      score = WIN
    when :paper
      score = LOSS
    when :scissors
      score = DRAW
    else
      abort 'Bug 3'
    end
  else
    abort 'Bug 4'
  end
  score
end

def score_round(shape, outcome)
  case shape
  when :rock
    1 + outcome
  when :paper
    2 + outcome
  when :scissors
    3 + outcome
  else
    abort 'Bug 5'
  end
end

def parse_pt1_input(inp)
  a = inp.split
  [parse(a.first), parse(a.last)]
end

puts 'Testing...'
oppo_play = parse('A')
my_play   = parse('Y')
score     = score_round(my_play, determine_round(oppo_play, my_play))
puts "A Y = #{score} #{'correct' if score == 8}"

oppo_play = parse('B')
my_play   = parse('X')
score     = score_round(my_play, determine_round(oppo_play, my_play))
puts "B Y = #{score} #{'correct' if score == 1}"

oppo_play = parse('C')
my_play   = parse('Z')
score     = score_round(my_play, determine_round(oppo_play, my_play))
puts "C Z = #{score} #{'correct' if score == 6}"

puts 'Processing input...'
input = File.readlines('input.txt', chomp: true)

tally = 0
input.each do |game|
  oppo_play, my_play = parse_pt1_input(game)
  tally += score_round(my_play, determine_round(oppo_play, my_play))
end

# Part 1
puts "Total score: #{tally}"

#------------- PART 2 -------------

def parse_outcome(outcome)
  case outcome
  when 'X'
    :lose
  when 'Y'
    :draw
  when 'Z'
    :win
  else
    abort 'Bug 6'
  end
end

def parse_pt2_input(inp)
  a = inp.split
  [parse(a.first), parse_outcome(a.last)]
end

def shape_to_win(oppo)
  case oppo
  when :rock
    :paper
  when :paper
    :scissors
  when :scissors
    :rock
  else
    abort 'Bug 7'
  end
end

def shape_to_draw(oppo)
  oppo
end

def shape_to_lose(oppo)
  case oppo
  when :rock
    :scissors
  when :paper
    :rock
  when :scissors
    :paper
  else
    abort 'Bug 8'
  end
end

def play_from_result(result, oppo_play)
  case result
  when :win
    shape_to_win(oppo_play)
  when :draw
    shape_to_draw(oppo_play)
  when :lose
    shape_to_lose(oppo_play)
  else
    abort 'Bug 9'
  end
end

puts 'Part 2'

puts 'Testing...'
oppo_play = parse('A')
result = parse_outcome('Y')
my_play = play_from_result(result, oppo_play)
score = score_round(my_play, determine_round(oppo_play, my_play))
puts "Score #{score} #{'correct' if score == 4}"

oppo_play = parse('B')
result = parse_outcome('X')
my_play = play_from_result(result, oppo_play)
score = score_round(my_play, determine_round(oppo_play, my_play))
puts "Score #{score} #{'correct' if score == 1}"

oppo_play = parse('C')
result = parse_outcome('Z')
my_play = play_from_result(result, oppo_play)
score = score_round(my_play, determine_round(oppo_play, my_play))
puts "Score #{score} #{'correct' if score == 7}"

puts 'Re-processing input...'

tally = 0
input = File.readlines('input.txt', chomp: true)

tally = 0
input.each do |game|
  oppo_play, result = parse_pt2_input(game)
  my_play = play_from_result(result, oppo_play)
  tally += score_round(my_play, determine_round(oppo_play, my_play))
end

puts "Total score : #{tally}"
