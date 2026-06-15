#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'ls_long_formatter'
require_relative 'ls_short_formatter'
require_relative 'entry'

class LsCommand
  def initialize(params)
    @params = params
  end

  def execute
    flags = @params['a'] ? File::FNM_DOTMATCH : 0
    names = Dir.glob('*', flags).sort
    names = @params['r'] ? names.reverse : names
    entries = names.map { |name| Entry.new(name) }
    formatter = @params['l'] ? LsLongFormatter.new(entries) : LsShortFormatter.new(entries)
    formatter.print_entries
  end
end
