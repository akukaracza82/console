# frozen_string_literal: true

module Helium
  class Console
    class ColorPrinter < Pry::ColorPrinter
      def self.pp(obj, output = $DEFAULT_OUTPUT, max_width = 79)
        queue = ColorPrinter.new(output, max_width, "\n")
        queue.guard_inspect_key { queue.pp(obj) }
        queue.flush
        output << "\n"
      end

      def pp(object)
        formatted = Helium::Console.format(object, max_width: maxwidth)
        start_new_line = formatted.is_a?(Registry::Element::LazyStringEvaluator)
        start_new_line ||= formatted.lines.count > 1
        start_new_line ||= length_of(formatted.chomp) >= maxwidth - 2
        output << "\n" if start_new_line

        formatted.lines.each.with_index do |line, index|
          output << "\n" unless index.zero?
          output << line.chomp
        end
      end

      def length_of(str)
        ColorizedString.new(str).uncolorize.length
      end
    end
  end
end