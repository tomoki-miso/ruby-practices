#!/usr/bin/env ruby
# frozen_string_literal: true

def fizzbuzz(number)
  if (number % 3).zero? && (number % 5).zero?
    'FizzBuzz'
  elsif (number % 3).zero?
    'Fizz'
  elsif (number % 5).zero?
    'Buzz'
  else
    number
  end
end

(1..20).each do |n|
  puts fizzbuzz(n)
end
