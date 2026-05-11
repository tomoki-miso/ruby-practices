#!/usr/bin/env ruby
require 'optparse'

COLUMN_SIZE = 3

def print_formatted_entries(entries)
  row_size = (entries.size.to_f / COLUMN_SIZE).ceil
  chunks = entries.each_slice(row_size).to_a

  column_widths = chunks.map do |chunk|
    chunk.map(&:length).max || 0
  end

  row_size.times do |row_index|
    line = chunks.each_with_index.map do |chunk, column_index|
      item = chunk[row_index]
      next nil unless item

      item.ljust(column_widths[column_index])
    end

    puts line.compact.join('  ')
  end
end

params = ARGV.getopts('r')

entries = Dir.glob('*')

entries.reverse! if params['r']

print_formatted_entries(entries)
