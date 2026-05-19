#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'optparse'

COLUMN_SIZE = 3

MODE_MAP = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

FTYPE_MAP = {
  'file' => '-',
  'directory' => 'd',
  'characterSpecial' => 'c',
  'blockSpecial' => 'b',
  'fifo' => 'p',
  'link' => 'l',
  'socket' => 's',
  'unknown' => '?'
}.freeze

def main
  params = ARGV.getopts('ral')

  flags = params['a'] ? File::FNM_DOTMATCH : 0
  entries = Dir.glob('*', flags).sort

  ordered_entries = params['r'] ? entries.reverse : entries

  if params['l']
    print_long_format(ordered_entries)
  else
    print_formatted_entries(ordered_entries)
  end
end

def print_formatted_entries(entries)
  row_size = (entries.size.to_f / COLUMN_SIZE).ceil
  chunks = entries.each_slice(row_size).to_a

  column_widths = chunks.map do |chunk|
    chunk.map(&:length).max || 0
  end

  row_size.times do |row_index|
    line = chunks.map.with_index do |chunk, column_index|
      item = chunk[row_index]
      next nil unless item

      item.ljust(column_widths[column_index])
    end

    puts line.compact.join('  ')
  end
end

def print_long_format(entries)
  rows = build_long_format_rows(entries)
  widths = column_widths(rows)

  puts "total #{rows.sum { |row| row[:block] }}"
  rows.each { |row| puts format_long_format_row(row, widths) }
end

def build_long_format_rows(entries)
  entries.map do |entry|
    stat = File.lstat(entry)

    {
      mode: "#{FTYPE_MAP[stat.ftype]}#{mode_to_string(stat.mode)}",
      nlink: stat.nlink.to_s,
      user: Etc.getpwuid(stat.uid).name,
      group: Etc.getgrgid(stat.gid).name,
      size: stat.size.to_s,
      mtime: stat.mtime.strftime('%b %e %R'),
      name: entry,
      block: stat.blocks
    }
  end
end

def column_widths(rows)
  %i[mode nlink user group size].to_h do |key|
    [key, rows.map { |row| row[key].length }.max]
  end
end

def format_long_format_row(row, widths)
  [
    row[:mode].ljust(widths[:mode]),
    row[:nlink].rjust(widths[:nlink]),
    row[:user].ljust(widths[:user]),
    row[:group].ljust(widths[:group]),
    row[:size].rjust(widths[:size]),
    row[:mtime],
    row[:name]
  ].join(' ')
end

def mode_to_string(mode)
  format('%03o', mode & 0o777).chars.map { |c| MODE_MAP[c] }.join
end

main
