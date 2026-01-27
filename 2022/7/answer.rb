#!/usr/bin/env ruby

INPUT = File.readlines('input.txt', chomp: true)

class FileSystem
  def initialize
    @tree = { '/' => {} }
    @current_dir = ['/']
  end

  def parse_cd(directory)
    return unless directory == '/' || @tree.dig(*@current_dir).keys.include?(directory)

    if directory == '..'
      @current_dir.pop
    elsif directory == '/'
      @current_dir = ['/']
    else
      @current_dir << directory
    end
  end

  def mkdir(dir)
    @tree.dig(*@current_dir).merge!(dir => { '..' => {} })
  end

  def add_file(filename, size)
    @tree.dig(*@current_dir).merge!(filename => size)
  end

  def parse_ls(index)
    while INPUT[index] !~ /\$.*/ && (index < INPUT.size)
      case INPUT[index]
      when /(?<size>[[:digit:]]+) (?<filename>[A-Za-z0-9.]+)/ # file
        m = Regexp.last_match
        add_file(m['filename'], m['size'])
      when /dir (?<dirname>[A-Za-z0-9.]+)/ # directory
        m = Regexp.last_match
        mkdir(m['dirname'])
      else
        puts "BUG: Didn't match on #{INPUT[index]} index #{index}"
      end
      index += 1
    end
    index
  end

  def size_of(dir)
    as_array = dir.split('-')
    size_of_dir(@tree.dig(*as_array), 0)
  end

  def dirs_in(dir, tally)
    as_array = dir.split('-')
    @tree.dig(*as_array).inject(tally) do |arrays, (name, ref)|
      if ref.is_a?(Hash) && (name != '..')
        sub_dir = "#{dir}-#{name}"
        arrays << sub_dir
        dirs_in(sub_dir, arrays)
      else
        arrays
      end
    end
  end

  private

  def size_of_dir(hash, tally)
    hash.inject(tally) do |tally, (_name, ref)|
      if ref.is_a? Hash # dir
        size_of_dir(ref, tally)
      else # file
        tally + ref.to_i
      end
    end
  end
end

fs = FileSystem.new

new_index = -1
INPUT.each_with_index do |line, index|
  next if new_index > index

  case line[0..3]
  when '$ cd'
    fs.parse_cd(line[5..])
  when '$ ls'
    new_index = fs.parse_ls(index + 1)
  end
end

size_of_root = fs.size_of('/')
dirs_in_root = fs.dirs_in('/', ['/'])

total = 0
dirs_in_root.each do |dir|
  size = fs.size_of(dir)
  total += size if size <= 100_000
end

puts "Part 1 - Grand total: #{total}"

size_dict = {}
dirs_in_root.each do |dir|
  size = fs.size_of(dir)
  size_dict[size] = dir # ignore dirs of the same size, not asked to name the dir
end

free_at_least = size_of_root - 40_000_000
puts "We need to free up #{free_at_least} bytes"

puts 'Part 2 - the smallest directory which sufficient space is:'
puts size_dict.sort_by { |k, _v| k }.select { |(k, _v)| k > free_at_least }.first
