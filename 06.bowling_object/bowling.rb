#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'
require_relative 'shot'

def main
  pins = ARGV[0]
  shots = pins.split(',').map { |pin| Shot.new(pin: pin) }

  game = Game.new(shots: shots)
  total = game.total_score

  puts total
end

main
