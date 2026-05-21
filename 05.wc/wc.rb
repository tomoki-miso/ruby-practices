# frozen_string_literal: true

require 'optparse'

def main
  opt = OptionParser.new
  options = {}

  opt.on('-w') { |v| options[:word] = v }
  opt.on('-c') { |v| options[:byte] = v }
  opt.on('-l') { |v| options[:line] = v }
  opt.parse!(ARGV)

  file_paths = ARGF.argv

  # ARGF.argvが空の場合は、標準入力から読み込む
  if file_paths.empty?
    input = ARGF.read
    output_counts(options, input)
  end

  file_paths.each do |path|
    input = File.read(path)
    output_counts(options, input, path)
  end
end

def output_counts(options, input, path = nil)
  no_options = options.empty?
  converted_options = no_options ? { line: true, word: true, byte: true } : options
  output = []

  output << calculate_counts(input)[:line] if converted_options[:line]
  output << calculate_counts(input)[:word] if converted_options[:word]
  output << calculate_counts(input)[:byte] if converted_options[:byte]

  output.each do |count|
    print count.to_s.rjust(8)
  end

  print " #{path}" if path
  puts ''
end

def calculate_counts(input)
  {
    line: input.lines.size,
    word: input.split.size,
    byte: input.bytesize
  }
end

main
