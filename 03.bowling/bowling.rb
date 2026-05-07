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

  def strike?
    scores.first == 'X'
  end

  def spare?
    frame_score == 10 && !strike?
  end

  def frame_score
    scores.map { |s| s == 'X' ? 10 : s.to_i }.sum
  end
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

frame_hash = {}

# 各フレームを　hash, Frame にして扱いやすくする
frames.size.times do |index|
  frame_hash[index] = Frame.new(scores: frames[index])
end

# 次と次の投球を得るために、次と次のフレームの中身を取り出す
# 次と次の投球なのは、ストライクが2回続いたときのために多めに取っている
def next_rolls(frame_hash, start_index)
  tmp =
    frame_hash[start_index + 1]&.scores.to_a +
    frame_hash[start_index + 2]&.scores.to_a

  tmp.map { |roll| roll == 'X' ? 10 : roll.to_i }
end

total = 0

# フレームごとに得点計算
frame_hash.each do |index, frame|
  nexts = next_rolls(frame_hash, index)

  frame.result =
    if index == 9
      frame.frame_score
    elsif frame.strike?
      frame.frame_score + nexts[0].to_i + nexts[1].to_i

    elsif frame.spare?
      frame.frame_score + nexts[0].to_i

    else
      frame.frame_score
    end

  total += frame.result
end
puts total
