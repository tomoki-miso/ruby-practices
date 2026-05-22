# frozen_string_literal: true

require 'optparse'

def main
  opt = OptionParser.new
  options = {}

  opt.on('-w') { options[:word] = true }
  opt.on('-c') { options[:byte] = true }
  opt.on('-l') { options[:line] = true }
  opt.parse!(ARGV)

  file_paths = ARGV

  if file_paths.empty?
    input = ARGF.read
    counts = calculate_counts(input)
    print_counts(options, counts)
    return
  end

  counts_list = file_paths.map do |path|
    input = File.read(path)
    counts = calculate_counts(input, path)

    print_counts(options, counts)

    counts
  end

  print_total_counts(options, counts_list) if counts_list.size >= 2
end

def print_counts(options, counts)
  selected_options = options.empty? ? { line: true, word: true, byte: true } : options
  output = []

  output << counts[:line] if selected_options[:line]
  output << counts[:word] if selected_options[:word]
  output << counts[:byte] if selected_options[:byte]

  output.each do |count|
    print count.to_s.rjust(8)
  end

  print " #{counts[:path]}" if counts[:path]
  puts
end

def calculate_counts(input, path = nil)
  {
    line: input.lines.size,
    word: input.split.size,
    byte: input.bytesize,
    path: path
  }
end

def print_total_counts(options, counts_list)
  total_counts = {
    line: counts_list.sum { |counts| counts[:line] },
    word: counts_list.sum { |counts| counts[:word] },
    byte: counts_list.sum { |counts| counts[:byte] },
    path: 'total'
  }

  print_counts(options, total_counts)
end

main