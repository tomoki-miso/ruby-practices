# frozen_string_literal: true

require_relative 'entry'

class LsLongFormatter
  def initialize(entries)
    @entries = entries
  end

  def print_entries
    widths = column_widths

    puts "total #{@entries.sum(&:blocks)}"

    @entries.each { |entry| puts format_long_format_row(entry, widths) }
  end

  private

  def column_widths
    %i[mode nlink user group size].to_h do |key|
      width = @entries.map { |entry| entry.public_send(key).length }.max
      [key, width]
    end
  end

  def format_long_format_row(entry, widths)
    [
      entry.mode.ljust(widths[:mode]),
      entry.nlink.rjust(widths[:nlink]),
      entry.user.ljust(widths[:user]),
      entry.group.ljust(widths[:group]),
      entry.size.rjust(widths[:size]),
      entry.mtime,
      entry.name
    ].join(' ')
  end
end
