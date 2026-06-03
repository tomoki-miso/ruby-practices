# frozen_string_literal: true

class Frame
  attr_reader :scores

  def initialize(scores:, last: false)
    @scores = scores
    @last = last
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

  def score_with_bonus(next_rolls)
    frame_score + bonus_score(next_rolls)
  end

  private

  def bonus_score(next_rolls)
    if @last
      0
    elsif strike?
      next_rolls[0] + next_rolls[1]
    elsif spare?
      next_rolls[0]
    else
      0
    end
  end
end
