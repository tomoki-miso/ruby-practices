# frozen_string_literal: true

class Frame
  attr_reader :scores

  def initialize(scores:)
    @scores = scores
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

  def score(next_rolls)
    frame_score + bonus_score(next_rolls)
  end

  private

  def bonus_score(next_rolls)
    if next_rolls.empty?
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
