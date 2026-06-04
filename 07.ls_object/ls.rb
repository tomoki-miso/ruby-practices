#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'ls_command'

def main
  params = ARGV.getopts('ral')
  LsCommand.new(params).execute
end

main
