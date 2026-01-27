#!/usr/bin/env ruby

# CEPHALOPOD MATHS
#
# In part 2 we are told the cephalopod numbers are read right to left
# in columns.
#

class CephalopodMathProblem
  def initialize
    @rows_chars = []
    @row_count = -1 # Account for ops row
    ARGF.each_line(chomp: true) do |line|
      @rows_chars << line.chars
      @row_count += 1
    end

    ops_chars = @rows_chars.pop.delete_if { |n| n == ' ' }
    @ops_syms = ops_chars.reverse.map(&:to_sym)

    @cols_chars = []
    @rows_chars[0].each { |_| @cols_chars << [] }

    @rows_chars.each do |row|
      row.each_with_index do |r, i|
        @cols_chars[i] << r
      end
    end

    cols_chars_to_cephalopod_numbers
    cephalopod_nums_to_sums
  end

  def show
    puts "Row_chars: #{@rows_chars}"
    puts "row_count: #{@row_count}"
    puts "Cols_chars: #{@cols_chars}"
    puts "ops_syms: #{@ops_syms}"
    puts "cephalopod_nums: #{@cephalopod_nums}"
    puts "cephalopod_sums: #{@cephalopod_sums}"
  end

  def cols_chars_to_cephalopod_numbers
    @cephalopod_nums = []
    @cols_chars.push(Array.new(@row_count, ''))
    @cols_chars.each do |col|
      @cephalopod_nums << col.delete_if { |n| n == ' ' }.join
    end
  end

  def cephalopod_nums_to_sums
    @cephalopod_sums = []
    sum = []
    @cephalopod_nums.each do |cn|
      if cn == ''
        # End of number
        @cephalopod_sums << sum.reverse.map(&:to_i)
        sum = []
      else
        sum << cn
      end
    end
    @cephalopod_sums.reverse!
  end

  def solve
    acc = 0
    @cephalopod_sums.each_with_index do |sum, i|
      acc += sum.reduce(@ops_syms[i])
    end
    acc
  end
end

problem = CephalopodMathProblem.new
puts "Part 2: #{problem.solve}"
