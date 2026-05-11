#!/usr/bin/env ruby
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
  # パーミッションの3-5桁目を取得
  # OS でも冒頭の'100'は省いた形を変換されているため
  mode.to_s(8)[3..5].chars.map { |char| MODE_MAP[char] }.join
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
    line = chunks.each_with_index.map do |chunk, column_index|
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
      mode:  "#{ftype_to_string(stat.ftype)}#{mode_to_string(stat.mode)}",
      nlink: stat.nlink.to_s,
      user:  Etc.getpwuid(stat.uid).name,
      group: Etc.getgrgid(stat.gid).name,
      size:  stat.size.to_s,
      mtime: stat.mtime.strftime('%b %e %R'),
      name:  entry,
      block: stat.blocks
    }
  end

  widths = {
    nlink: rows.map { |r| r[:nlink].length }.max,
    user:  rows.map { |r| r[:user].length }.max,
    group: rows.map { |r| r[:group].length }.max,
    size:  rows.map { |r| r[:size].length }.max
  }

  puts "total #{rows.sum { |r| r[:block]}}"
  rows.each do |r|
    puts "#{r[:mode]} #{r[:nlink].rjust(widths[:nlink])} " \
         "#{r[:user].ljust(widths[:user])} #{r[:group].ljust(widths[:group])} " \
         "#{r[:size].rjust(widths[:size])} #{r[:mtime]} #{r[:name]}"
  end
end


params = ARGV.getopts('l')
entries = Dir.glob('*')

if params['l']
  print_long_format(entries)
else
  print_formatted_entries(entries)
end
