#!/usr/bin/env ruby

# CAPHALOPOD MATHS
#
# We are given an input of rows and columns of integers with
# arithmetic operators in the last row.
#
# 123 328  51 64
#  45 64  387 23
#   6 98  215 314
# *   +   *   +
#
# In part 1 we are asked to apply the operator to the column and sum
# the results.
#
# We read the input so that we can access it in columns then
# use reduce with the relevant operator.

class MathProblem
  def initialize
    @rows_strings = ARGF.each_line(chomp: true).map(&:split)
    @operations = @rows_strings.pop.map(&:to_sym)
    @rows = @rows_strings.map { |row| row.map(&:to_i) }
    @cols = Array.new(@rows[0].size) { [] }

    @rows.each do |row|
      row.each_with_index do |r, i|
        @cols[i] << r
      end
    end
  end

  def solve_part1
    acc = 0
    @cols.each_with_index do |col, i|
      acc += col.reduce(@operations[i])
    end
    acc
  end
end

m = MathProblem.new
puts "Part 1: #{m.solve_part1}"
