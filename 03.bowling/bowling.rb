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
    scores.first == 'X'
  end

  def spare?
    frame_score == 10 && !strike?
  end

  def frame_score
    scores.map { |s| roll_score(s) }.sum
  end

  def roll_score(roll)
    roll == 'X' ? 10 : roll.to_i
  end
end


def next_rolls(frames, start_index)
  frames[(start_index + 1)..]&.flatten || []
end

score = ARGV[0]
scores = score.split(',')
shots = []

scores.each do |s|
  if s == 'X'
    shots << 'X'
    shots << 0
  else
    shots << s
  end
end

# ['X', 0]　はストライクの場合なので、X 単体で1フレームとする
frames = shots.each_slice(2).to_a.map { |frame| frame == ['X', 0] ? ['X'] : frame }

# 10フレーム目の追加投球が別フレームとして分割された場合、10フレーム目に結合する
while frames.size > 10
  frames[9] = frames[9] + frames[10]
  frames.delete_at(10)
end

total = 0

frames.each_with_index do |frame_scores, index|
  frame = Frame.new(scores: frame_scores)
  nexts = next_rolls(frames, index)

  frame.result =
    if index == 9
      frame.frame_score
    elsif frame.strike?
      frame.frame_score + frame.roll_score(nexts[0]) + frame.roll_score(nexts[1])
    elsif frame.spare?
      frame.frame_score + frame.roll_score(nexts[0])
    else
      frame.frame_score
    end

  total += frame.result
end

puts total
