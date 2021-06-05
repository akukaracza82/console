module Helium
  class Console
    define_formatter_for String do
      def call
        Helium::Console.format_string(
          object.dump.gsub('\n', "\n"),
          max_width: max_width,
          max_lines: max_lines,
          overflow: overflow,
          ellipses: "...\""
        )
      end

      def max_lines
        return options[:max_lines] if options[:max_lines]
        case level
        when 1 then nil
        when 2 then 3
        else 1
        end
      end
    end
  end
end
