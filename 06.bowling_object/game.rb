# frozen_string_literal: true

require_relative 'frame'

class Game

  def initialize(shots:)
    shot_index = 0
    @frames = []
    9.times do
      if shots[shot_index].pin == 10
        @frames << Frame.new(scores: [10])
        shot_index += 1
      else
        @frames << Frame.new(scores: shots[shot_index, 2].map(&:pin))
        shot_index += 2
      end
    end

    # 10フレーム目は残り全部
    @frames << Frame.new(scores: shots[shot_index..].map(&:pin))
  end

  def total_score
    @frames.each_with_index.sum do |frame, frame_number|
      nexts = next_rolls(@frames, frame_number)
      frame.score(nexts)
    end
  end

  private

  def next_rolls(frames, start_index)
    frames.drop(start_index + 1).flat_map(&:scores)
  end
end
