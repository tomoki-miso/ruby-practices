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

def mode_to_string(mode)
  format('%03o', mode & 0o777).chars.map { |c| MODE_MAP[c] }.join
end

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

def ftype_to_string(ftype)
  FTYPE_MAP[ftype]
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
  rows = entries.map do |entry|
    stat = File.lstat(entry)
    {
      mode: "#{ftype_to_string(stat.ftype)}#{mode_to_string(stat.mode)}",
      nlink: stat.nlink.to_s,
      user: Etc.getpwuid(stat.uid).name,
      group: Etc.getgrgid(stat.gid).name,
      size: stat.size.to_s,
      mtime: stat.mtime.strftime('%b %e %R'),
      name: entry,
      block: stat.blocks
    }
  end

  widths = %i[mode nlink user group size].to_h { |k| [k, rows.map { |r| r[k].length }.max] }

  puts "total #{rows.sum { |r| r[:block] }}"
  rows.each do |r|
    puts "#{r[:mode].ljust(widths[:mode])} #{r[:nlink].rjust(widths[:nlink])} " \
         "#{r[:user].ljust(widths[:user])} #{r[:group].ljust(widths[:group])} " \
         "#{r[:size].rjust(widths[:size])} #{r[:mtime]} #{r[:name]}"
  end
end

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

main
