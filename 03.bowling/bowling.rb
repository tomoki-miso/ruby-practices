#!/usr/bin/env ruby
# frozen_string_literal: true

class Frame
  attr_accessor :result
  attr_reader :scores

  def initialize(scores:)
    @scores = scores
    @result = nil
  end

  def strike?
    scores.first == 10
  end

  def spare?
    scores.size == 2 && scores[0] + scores[1] == 10 && !strike?
  end

  def frame_score
    scores.sum
  end
end

def next_rolls(frames, start_index)
  frames.drop(start_index + 1).flat_map(&:scores)
end

score = ARGV[0]
scores = score.split(',').map { |s| s == 'X' ? 10 : s.to_i }

frames = []

shot_index = 0
9.times do
  if scores[shot_index] == 10
    frames << Frame.new(scores: [10])
    shot_index += 1
  else
    frames << Frame.new(scores: scores[shot_index, 2])
    shot_index += 2
  end
end

# 10フレーム目は残り全部
frames << Frame.new(scores: scores[shot_index..])

total = frames.each_with_index.sum do |frame, index|
  nexts = next_rolls(frames, index)
  each_frame_score = frame.frame_score

  frame.result = frame.frame_score + 
  case
  when index == 9 then 0
  when frame.strike? then nexts[0] + nexts[1]
  when frame.spare?  then nexts[0]
  else 0
  end
end

puts total
