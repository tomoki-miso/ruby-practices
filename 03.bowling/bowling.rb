#!/usr/bin/env ruby
# frozen_string_literal: true


# フレームのクラスを定義
class Frame
  attr_accessor :result
  attr_reader :scores
  
  def initialize(scores:)
    @scores = scores
    @result = nil
  end
  
  def isStrike?
    scores.first == 'X'
  end
  
  def isSpare?
    frameScore == 10 && !isStrike?
  end
  
  def frameScore
    scores.map { |s| s == 'X' ? 10 : s.to_i }.sum
  end
end

score = ARGV[0]
scores = score.split(',')
shots = []

# score を shots に入れる
scores.each do |s|
  # 'X' の場合は、
  if s == 'X'
    shots << 'X'
    shots << 0
  else
    shots << s
  end
end


frames = shots.each_slice(2).to_a.map { |frame| frame == ['X', 0] ? ['X'] : frame }
while frames.size > 10
  frames[9] = frames[9] + frames[10]
  frames.delete_at(10)
end

frame_hash = {}

frames.size.times do |index|
  frame_hash[index] = Frame.new(scores: frames[index])
end

def next_rolls(frame_hash, start_index)
  tmp =
    frame_hash[start_index + 1]&.scores.to_a +
    frame_hash[start_index + 2]&.scores.to_a

  tmp.map { |roll| roll == 'X' ? 10 : roll.to_i }
end

total = 0

frame_hash.each do |index, frame|
  nexts = next_rolls(frame_hash, index)

  frame.result =
    if frame.isStrike?
      frame.frameScore + nexts[0].to_i + nexts[1].to_i

    elsif frame.isSpare?
      frame.frameScore + nexts[0].to_i

    else
      frame.frameScore
    end

  total += frame.result
end
p total
