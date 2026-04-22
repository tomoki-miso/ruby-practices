#!/usr/bin/env ruby
# frozen_string_literal: true

require "optparse"
require "date"
opt = OptionParser.new

week_names = %w[日 月 火 水 木 金 土]
params = {}

# 入力
opt.on("-y VAL", Integer) { |v| params[:y] = v }
opt.on("-m VAL", Integer) { |v| params[:m] = v }

begin
  opt.parse!(ARGV)

  today = Date.today
  year = params.fetch(:y, today.year)
  month = params.fetch(:m, today.month)

  start_day = Date.new(year, month, 1)
  end_day = Date.new(year, month, -1)
rescue OptionParser::ParseError => e
  warn "正しいオプションを入れてね\n#{e}"
  exit 1
rescue Date::Error
  warn "正しい年月を入れてね（例: -y 2026 -m 1)"
  exit 1
end

days = Array.new(start_day.wday) + (start_day..end_day).to_a

# 出力
puts "#{month}月 #{year}".center(20)
week_names.each { |w| print w.center(2) }
puts

days.each_slice(7) do |week|
  week.each do |day|
    print day.nil? ? " ".center(3) : day.day.to_s.center(3)
  end
  puts
end
