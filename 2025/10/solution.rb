#!/usr/bin/env ruby
require 'debug'
require 'matrix'

class Puzzle
  # The manual describes one machine per line. Each line contains a
  # single indicator light diagram in [square brackets], one or more
  # button wiring schematics in (parentheses), and joltage
  # requirements in {curly braces}.
  #
  # [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
  class Machine
    attr_reader :target_lights, :buttons, :working_combos, :valid_patterns, :joltage

    class Lights
      attr_reader :bulbs

      def initialize(str) = @bulbs = str
      def toggle(b) = @bulbs[b] = @bulbs[b] == '.' ? '#' : '.'
      def number = @bulbs.size
      def ==(other) = @bulbs == other.bulbs
      def show = @bulbs
    end

    # Machine
    def initialize(l, b, j)
      @target_lights = Lights.new(l)
      reset_lights # sets up @current_state_lights
      @buttons = b # Array of integer arrays: [ [3], [1,3], [2], [2,3],.. ]
      @working_combos = []
      @joltage = make_joltage(j) # Array of ints
      @valid_patterns = {}
      @cache = {}
    end

    # A button is an array of integers
    def apply_button(b) = b.each { |btn| @current_state_lights.toggle(btn) }
    def button_combinations(n) = @buttons.combination(n)
    def target_achieved? = @current_state_lights == @target_lights
    def reset_lights = @current_state_lights = Lights.new('.' * @target_lights.number)
    # Record number of button presses
    def add_working_combo(c) = @working_combos << c.size
    def make_joltage(j) = j[1..-2].split(',').map(&:to_i)
    def show = @target_lights.show

    # Pre-calc what joltage increments this machine's buttons create
    # when pressed in every combination and store the number of button
    # presses with it.  e.g. Joltage changes (2, 1, 3, 2) "costs" 5
    # button presses. The joltage changes are generated from combos
    # of the buttons
    #
    # For every combination of button presses, calculate the joltage
    # changes Store the number of button presses along with that
    # combination of joltage changes.
    def compute_joltage_change_button_presses
      0.upto(@buttons.size).each do |num_presses|
        button_combinations(num_presses).each do |presses|
          tmp_joltage = Array.new(@joltage.size) { 0 }
          presses.each { |p| p.each { |p| tmp_joltage[p] += 1 } }
          # Don't overwrite an earlier pattern, it will have fewer presses
          @valid_patterns[tmp_joltage] = num_presses unless @valid_patterns.key? tmp_joltage
        end
      end
    end

    # A recursive approach.
    # The joltage increments caused by the provided buttons when
    # pressed in every combination are in @valid_patterns (compute_joltage_change_button_presses)
    #    e.g. Joltage changes (2, 1, 3, 2) "costs" 5 button presses.
    # We are "working backwards" from the goal joltage, so increments are subtracted...
    # Then, for a goal joltage, e.g. (3,5,4,7)
    #   If the goal is all zeros, return 0
    #   Go through all the available joltage increment "patterns"...
    #     If the inc would not make the joltage negative when subtracted,
    #     and the inc has the same parity as the joltage so when subtracted it will give an even joltage,
    #     then make a new goal of half the adjusted joltage
    #     and add [number_presses (pattern cost) + 2 x solve(new_goal)] to an array of answers
    #  return the min of the array when the recursions have all terminated
    def get_min_presses(goal)
      return @cache[goal] if @cache.key?(goal) # Memoisation
      return 0 if goal.all?(&:zero?)

      answer = 1_000_000 # Much larger than any answer so keeps out of the way of the min
      @valid_patterns.each_pair do |pattern, presses|
        next unless pattern.zip(goal).all? do |p, g|
          p <= g && (p % 2 == g % 2)
        end

        new_goal = pattern.zip(goal).map { |p, g| (g - p) / 2 } # Ok to /2 because parity same.
        answer = [answer, presses + (2 * get_min_presses(new_goal))].min # Recurse
      end

      @cache[goal] = answer # Memoisation
      answer
    end
  end

  # Puzzle
  def initialize
    # Input lines look like this
    # [.##.]  (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
    # <lights><---------- buttons ----------> < joltage>
    @machines = ARGF.each_line(chmop: true).map do |l|
      parts = l.split
      lights = parts.delete_at(0)[1..-2] # Zeroth item, strip [square brackets]
      joltage = parts.pop
      buttons = parts
                .map { |b| b[1..-2] } # Remove (parentheses)
                .map { |s| s.split(',') }
                .map { |a| a.map(&:to_i) }
      Machine.new(lights, buttons, joltage)
    end
  end

  def part1
    @machines.each do |m|
      n_combos = 0
      loop do
        n_combos += 1
        m.button_combinations(n_combos).each do |combo|
          combo.each { |b| m.apply_button(b) }
          m.add_working_combo(combo) if m.target_achieved?
          m.reset_lights
        end
        break if m.working_combos.any?
      end
    end
    # We are asked to determine the fewest total presses to configure indicator lights for all machines
    puts "Part 1: #{@machines.map { |m| m.working_combos.min }.reduce(:+)}"
  end

  def part2
    total_presses = @machines.map do |m|
      m.compute_joltage_change_button_presses
      m.get_min_presses(m.joltage) # Minimum presses to achieve the machine's joltage
    end.reduce(:+)
    puts "Part 2: #{total_presses}"
  end
end

p = Puzzle.new
p.part1
# Takes a while to run, so warn the user
puts 'Working on part 2...'
p.part2
