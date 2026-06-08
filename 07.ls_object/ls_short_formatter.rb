# frozen_string_literal: true

class LsShortFormatter
  COLUMN_SIZE = 3
  def initialize(entries)
    @entries = entries
  end

  def print_entries
    row_size = (@entries.size.to_f / COLUMN_SIZE).ceil
    chunks = @entries.each_slice(row_size).to_a

    column_widths = chunks.map do |chunk|
      chunk.map { |e| e.name.length }.max || 0
    end

    row_size.times do |row_index|
      line = chunks.map.with_index do |chunk, column_index|
        item = chunk[row_index]
        next nil unless item

        item.name.ljust(column_widths[column_index])
      end

      puts line.compact.join('  ')
    end
  end
end
