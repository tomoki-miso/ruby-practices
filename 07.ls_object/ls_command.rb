#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'ls_long_formatter'
require_relative 'ls_short_formatter'
require_relative 'entry'

class LsCommand
  attr_reader :printer

  def initialize(params)
    flags = params['a'] ? File::FNM_DOTMATCH : 0
    names = Dir.glob('*', flags).sort
    names = params['r'] ? names.reverse : names
    entries = names.map { |name| Entry.new(name) }
    @formatter = params['l'] ? LsLongFormatter.new(entries) : LsShortFormatter.new(entries)
  end

  def execute
    @formatter.print_entries
  end
end
