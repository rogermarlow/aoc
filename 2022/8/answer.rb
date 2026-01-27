#!/usr/bin/env ruby

# Day 8 Answer
#
# test.txt
#
# 30373
# 25512
# 65332
# 33549
# 35390
#             0  1  2  3  4
# Rows: {0=>[ 3, 0, 3, 7, 3 ],
#        1=>[ 2, 5, 5, 1, 2 ],
#        2=>[ 6, 5, 3, 3, 2 ],
#        3=>[ 3, 3, 5, 4, 9 ],
#        4=>[ 3, 5, 3, 9, 0 ]}
# Cols: {0=>[ 3, 2, 6, 3, 3 ],
#        1=>[ 0, 5, 5, 3, 5 ],
#        2=>[ 3, 5, 3, 5, 3 ],
#        3=>[ 7, 1, 3, 4, 9 ],
#        4=>[ 3, 2, 2, 9, 0 ]}
#
# visibility = { 0 => [ [:left], [:top, :left], [], [], []   ],
#                1 => [ [], [], [], [], []   ],
#                 .. }
#
# viewing_distance = { 0 => [ [ 0,1,3,0 ], [ 3,1,2,1 ], [ 1,1,0,0 ] ... ],
#                      1 => [ [ .. ] , ... ],
#                        ..
#

input = File.readlines('input.txt', chomp: true)

viewing_distance = {}
visibility = {}
rows = {}
cols = {}

input.each_with_index do |line, row_index|
  visibility[row_index] = []
  viewing_distance[row_index] = []
  rows[row_index] = line.chars.map(&:to_i)
  rows[row_index].each_with_index do |height, col_index|
    visibility[row_index] << []
    viewing_distance[row_index] << []
    if cols.key?(col_index)
      cols[col_index] << height
    else
      cols[col_index] = [height]
    end
  end
end

# Visible from left
direction = :left
rows.each do |(row_index, row)|
  highest = -1
  row.each_with_index do |h, col_index|
    if h > highest
      highest = h
      visibility[row_index][col_index] << direction
    end
  end
end

# Visible from right
direction = :right
rows.each do |(row_index, row)|
  highest = -1
  row.to_enum.with_index.reverse_each do |h, col_index|
    if h > highest
      highest = h
      visibility[row_index][col_index] << direction
    end
  end
  # puts "Row #{row_index} visibility #{visibility[row_index]}"
end

# Visible from top
direction = :top
cols.each do |(col_index, col)|
  highest = -1
  col.each_with_index do |h, row_index|
    if h > highest
      highest = h
      visibility[row_index][col_index] << direction
    end
  end
end

# Visible from bottom
direction = :bottom
cols.each do |(col_index, col)|
  highest = -1
  col.to_enum.with_index.reverse_each do |h, row_index|
    if h > highest
      highest = h
      visibility[row_index][col_index] << direction
    end
  end
end

# Count invisible trees
invisible = 0
visibility.each do |(_row, vis)|
  invisible += vis.count(&:empty?)
end

puts "Part 1 - #{(rows.count * cols.count) - invisible} visible."

# Viewing distance to the left
rows.each do |(r, trees)|
  trees.each_with_index do |h, index|
    distance = 0
    (index - 1).downto(0) do |n|
      if trees[n] >= h || n.zero?
        distance = index - n
        break
      end
    end
    viewing_distance[r][index] << distance
  end
end

# Viewing distance to the right
ROW_END = rows[0].size - 1
rows.each do |(r, trees)|
  trees.each_with_index do |h, index|
    distance = 0
    (index + 1).upto(ROW_END) do |n|
      if trees[n] >= h || n == ROW_END
        distance = n - index
        break
      end
    end
    viewing_distance[r][index] << distance
  end
end

# Viewing distance down
COL_END = cols[0].size - 1
cols.each do |(c, trees)|
  trees.each_with_index do |h, index|
    distance = 0
    (index + 1).upto(COL_END) do |n|
      if trees[n] >= h || n == COL_END
        distance = n - index
        break
      end
    end
    viewing_distance[index][c] << distance

    # Viewing distance up
    distance = 0
    (index - 1).downto(0) do |n|
      if trees[n] >= h || n.zero?
        distance = index - n
        break
      end
    end
    viewing_distance[index][c] << distance
  end
end

# vd = {0=>[[0, 2, 2, 0], [1, 1, 1, 1], [2, 1, 2, 2], [3, 1, 1, 1], [1, 0, 0, 1]],
#       1=>[[0, 1, 1, 0], [1, 1, 1, 1], [1, 2, 2, 1], [1, 1, 1, 1], [2, 0, 0, 2]],
#       2=>[[0, 4, 1, 0], [1, 3, 2, 1], [1, 1, 1, 1], [1, 1, 1, 2], [1, 0, 0, 1]],
#       3=>[[0, 1, 4, 0], [1, 1, 1, 1], [2, 2, 1, 2], [1, 1, 1, 3], [4, 0, 0, 4]],
#       4=>[[0, 1, 3, 0], [1, 2, 1, 1], [1, 1, 1, 1], [3, 1, 1, 3], [1, 0, 0, 1]]}

# ss = {0=>[0, 0, 0, 0, 0],
#       1=>[0, 1, 4, 1, 0],
#       2=>[0, 6, 1, 2, 0],
#       3=>[0, 1, 8, 3, 0],
#       4=>[0, 0, 0, 0, 0]}

ss = {}
viewing_distance.each do |(row, vds)|
  vds.each do |vd|
    if ss.key? row
      ss[row] << vd.inject(:*)
    else
      ss[row] = [vd.inject(:*)]
    end
  end
end

row_maxes = ss.map { |(_r, scores)| scores.max }
puts "Part 2 - Highest scenic score: #{row_maxes.max}."
