# frozen_string_literal: true

require 'etc'

class Entry
  attr_reader :name, :mode, :nlink, :user, :group, :size, :mtime, :blocks

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

  def initialize(name)
    @name = name
    @stat = File.lstat(@name)
  end

  def mode = "#{FTYPE_MAP.fetch(@stat.ftype)}#{mode_to_string(@stat.mode)}"
  def nlink = @stat.nlink.to_s
  def user = Etc.getpwuid(@stat.uid).name
  def group = Etc.getgrgid(@stat.gid).name
  def size = @stat.size.to_s
  def mtime = @stat.mtime.strftime('%b %e %R')
  def blocks = @stat.blocks


  private

  def mode_to_string(mode)
    format('%03o', mode & 0o777).chars.map { |c| MODE_MAP[c] }.join
  end
end
