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
        formatted = Helium::Console.format(object)
        output << "\n" if object.is_a? Registry::Element::LazyStringEvaluator
        formatted.lines.each.with_index do |line, index|
          output << "\n" unless index.zero?
          output << line.chomp
        end
      end
    end
  end
end
