module Helium
  class Console
    define_formatter_for String do
      def call
        formatted = Helium::Console.format_string(
          object.dump.gsub('\n', "\n"),
          max_width: max_width,
          max_lines: max_lines,
          overflow: overflow,
          ellipses: "...\""
        )

        formatted.lines
          .map { |line| light_green(line) }
          .join
      end

      def max_lines
        case level
        when 1 then nil
        when 2 then 3
        else 1
        end
      end
    end
  end
end
