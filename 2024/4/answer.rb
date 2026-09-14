#!/usr/bin/env ruby

class Puzzle
  def initialize
    @grid   = ARGF.readlines(chomp: true)
    @matrix = @grid.map(&:chars) # Explode strings into chars
    @rows   = @grid.size
    @cols   = @matrix.first.size
  end

  def part1
    puts "Part 1: #{grid_in_all_directions.sum { |row| row.scan('XMAS').count }}"
  end

  # Observation 1: Regardless of orientation, 'A' is always the centre of a MAS cross.
  # Observation 2: Crosses dont wrap around the grid edges, so the central A cannot be
  #                on the first or last row or column. Indexes run from 0 to @cols-1
  def part2
    calc_xmas_corners

    crosses = 0
    (1..(@cols - 2)).each do |col|
      (1..(@rows - 2)).each do |row|
        crosses += one_if_cross(row, col)
      end
    end
    puts "Part 2: #{crosses}"
  end

  private

  # Part 1 helper
  def grid_in_all_directions
    # We are supporting word search in a grid. We can only search
    # "forward" with scan() so for the other directions we make copies
    # of the grid on those directions.  Return an array of strings
    # that are the rows, columns and diagonals in both directions

    # Start with grid as given, the normal "forward" sense of words.
    forward = @grid

    # Now calc diagonals and cols.
    # The insight is to think of diagonals as lines with slope 1,
    # with y intercept 0,1,2,3, or y = x + {0,1,2,3}
    #
    # So all the cells on a particular diagonal, say y = x + 2,
    # satisfy y-x = 2. If we use "2" as the hash key and put all cells
    # where y-x = 2 in that bucket, the concatenation of everything in
    # that bucket is the string on the diagonal.
    #
    # Diagonals the other way are lines with slope -1, going through
    # y intercept -3,-2,-1,0,1,2,3. or y = -x + {-3,-2,-1,0,1,2,3}
    # So cells on those diagonals satisfy y+x = {-3,-2,..}
    #
    # In fact we only have to calc diagonals in two directions and
    # cols top to bottom, the diagonals and cols in the other direction
    # are just their reverse.
    down_right = Hash.new { |h, k| h[k] = [] }
    down_left  = Hash.new { |h, k| h[k] = [] }
    top_bottom = Hash.new { |h, k| h[k] = [] }
    @matrix.each_with_index do |row, r|
      row.each_with_index do |ch, c|
        down_right[r - c] << ch
        down_left[r + c]  << ch
        top_bottom[c] << ch
      end
    end

    # Discard the keys used to bucket the diagonals and cols,
    # leaving just the chars which we join into strings.
    forward += [down_right, down_left, top_bottom].flat_map { |h| h.map { |_, v| v.join } }
    # Add in the reverses of diagonals and cols to give up_left, up_right and cols bottom to top
    forward + forward.map(&:reverse)
  end

  # Part 2 helpers
  def one_if_cross(row, col)
    return 0 unless @matrix[row][col] == 'A'

    # Extract corners around the A at row,col
    corners =  @matrix[row - 1][col - 1] \
             + @matrix[row - 1][col + 1] \
             + @matrix[row + 1][col - 1] \
             + @matrix[row + 1][col + 1]
    # Return 1 if they match any of our pre-calculated corners, 0 otherwise
    @corners.count { |pre_calc| pre_calc == corners }
  end

  # Pre-calc the four rotations of the MAS cross (M.M on the left, top, right, bottom)
  # Note how A is always central, which is the insight for how to
  # search for a cross, i.e. search for A then check the corners.
  def calc_xmas_corners
    @corners = []

    # M's on the left:
    # M.S
    # .A.
    # M.S
    @corners << 'MMSS'

    # M's at the top:
    # M.M
    # .A.
    # S.S
    @corners << 'MSMS'

    # M's on the right:
    # S.M
    # .A.
    # S.M
    @corners << 'SMSM'

    # M's at the bottom:
    # S.S
    # .A.
    # M.M
    @corners << 'SSMM'
  end
end

p = Puzzle.new
p.part1
p.part2
