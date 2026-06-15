# frozen_string_literal: true

require_relative 'entry'

class LsLongFormatter
  def print_entries(entries)
    puts "total #{entries.sum(&:blocks)}"
    widths = column_widths(entries)
    entries.each { |entry| puts long_format_row(entry, widths) }
  end

  private

  def column_widths(entries)
    %i[mode nlink user group size].to_h do |key|
      width = entries.map { |entry| entry.public_send(key).to_s.length }.max
      [key, width]
    end
  end

  def long_format_row(entry, widths)
    [
      entry.mode.ljust(widths[:mode]),
      entry.nlink.to_s.rjust(widths[:nlink]),
      entry.user.ljust(widths[:user]),
      entry.group.ljust(widths[:group]),
      entry.size.to_s.rjust(widths[:size]),
      entry.mtime.strftime('%-m月 %e %H:%M'),
      entry.name
    ].join(' ')
  end
end
