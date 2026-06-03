# frozen_string_literal: true

class Shot
  attr_reader :pin

  def initialize(pin:)
    @pin = pin == 'X' ? 10 : pin.to_i
  end
end
