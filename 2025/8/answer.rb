#!/usr/bin/env ruby

# CONNECTING JUNCTION BOXES
#
# The input is a list of points in 3D space:
# 162,817,812
# 57,618,57
# 906,360,560
# 592,479,940
# 352,342,300
#
# We are asked to find the closest points and "connect" them, then
# repeat. This creates "circuits".  In part 1 we find the three
# largest circuits and multiple together their lengths.  In part 2 we
# connect all the circuits. The last ones to be conencted have their x
# coordinates multiplied to give the answer.
#
# We use a Disjoint Set Union (DSU) to represent circuits. This is
# just an array of integers. The position in the array represents 'n'
# and the array value at n tells us which set (circuit) it is in.
#
# answer.rb tiny.txt
# answer.rb input.txt

class Puzzle
  # Dis-joint set union.
  # https://cp-algorithms.com/data_structures/disjoint_set_union.html
  class Dsu
    def initialize(n)
      @parent = Array.new(n) { |i| i }
    end

    def find(n)
      return n if n == @parent[n]

      find(@parent[n])
    end

    # False if a and b are already in the same set
    # True if b is added to a's set
    def union?(a, b)
      root_a = find(a)
      root_b = find(b)
      return false if root_a == root_b

      @parent[root_b] = root_a
      true
    end
  end

  class JunctionBox
    def initialize
      @points = ARGF.readlines.map { |l| l.split(',').map(&:to_i) }
    end

    def num_points = @points.size

    def build_sorted_edges
      @edges = []
      n = @points.size
      0.upto(n - 1) do |p|
        p1, p2, p3 = @points[p]
        (p + 1).upto(n - 1) do |q|
          q1, q2, q3 = @points[q]

          d_sq = ((p1 - q1)**2) + ((p2 - q2)**2) + ((p3 - q3)**2)
          @edges << [d_sq, p, q]
        end
      end
      @edges.sort_by!(&:first)
    end

    def build_circuits
      @dsu = Dsu.new(num_points)
      @edges.take(num_points).each { |(_, i, j)| @dsu.union?(i, j) } # Put i and j in the same circuit
    end

    def part_1
      circuit_sizes = Hash.new(0)
      # Count how many DSU entries have the same root
      0.upto(num_points - 1) { |i| circuit_sizes[@dsu.find(i)] += 1 }
      circuit_sizes.values.sort.reverse.first(3).reduce(:*)
    end

    def part_2
      @dsu = Dsu.new(num_points)
      points_in_circuit = 0
      last_edge = nil
      @edges.each do |(_, i, j)|
        next unless @dsu.union?(i, j)

        last_edge = [i, j]
        points_in_circuit += 1
        break if points_in_circuit == num_points
      end
      @points[last_edge[0]][0] * @points[last_edge[1]][0]
    end
  end

  def solve
    j = JunctionBox.new
    j.build_sorted_edges
    j.build_circuits
    puts "Part 1: #{j.part_1}"
    puts "Part 2: #{j.part_2}"
  end
end

Puzzle.new.solve
