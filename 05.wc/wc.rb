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

  line_count = input.lines.size if no_options || options[:line]
  word_count = input.split.size if no_options || options[:word]
  byte_count = input.bytesize if no_options || options[:byte]

  puts "#{line_count.to_s.rjust(8)}#{word_count.to_s.rjust(8)}#{byte_count.to_s.rjust(8)} #{path}"
end

main
