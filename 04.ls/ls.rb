#!/usr/bin/env ruby

def print_formatted_array(array)
  column_size = 3
  row_size = (array.size.to_f / column_size).ceil

  chunks = array.each_slice(row_size).to_a

  row_size.times do |row_index|
    line = chunks.map { |chunk| chunk[row_index] }
    puts line.join(" ")
  end
end

print_formatted_array(Dir.glob("*").sort)
