#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'ls_long_formatter'
require_relative 'ls_short_formatter'
require_relative 'entry'

class LsCommand
  def initialize(all: false, reverse: false, long: false)
    @all = all
    @reverse = reverse
    @formatter = long ? LsLongFormatter.new : LsShortFormatter.new
  end

  def execute
    entries = collect_entries
    @formatter.print_entries(entries)
  end

  private

  def collect_entries
    flags = @all ? File::FNM_DOTMATCH : 0
    names = Dir.glob('*', flags).sort
    names = @reverse ? names.reverse : names
    names.map { |name| Entry.new(name) }
  end
end
