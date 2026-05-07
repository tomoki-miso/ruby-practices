#!/usr/bin/env ruby

COLUMN_SIZE = 3

def print_formatted_entries(entries)
  row_size = (entries.size.to_f / COLUMN_SIZE).ceil

  chunks = entries.each_slice(row_size).to_a

  row_size.times do |row_index|
    line = chunks.map { |chunk| chunk[row_index] }
    puts line.join(" ")
  end
end

print_formatted_entries(Dir.glob("*").sort)
