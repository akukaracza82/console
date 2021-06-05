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
        formatted = $/ + formatted if formatted.lines.count > 1
        output << formatted
      end

      ::Pry.config.print = self.method(:default)
    end
  end
end
