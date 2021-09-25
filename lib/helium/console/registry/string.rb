# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for String do
      def render_compact
        render_string(object, max_width: 15, max_lines: 1)
      end

      def render_inline
        render_string(object.gsub("\n", '\n'), max_lines: 1)
      end

      def render_partial
        render_string(object, max_lines: max_lines || 3)
      end

      def render_full
        render_string(object)
      end

      def simple?
        object.lines.count == 1 && length_of(object) < 15
      end

      def render_string(string, max_lines: self.max_lines, max_width: self.max_width)
        formatted = format_string(
          "\"#{string.gsub('"', '\"')}\"",
          max_width: max_width,
          max_lines: max_lines,
          overflow: overflow,
          ellipses: '..."',
          indent: indent
        )

        result = formatted.lines
          .map { |line| light_green(line.chomp) }
          .join("\n")

        result = "#{result}\n" if formatted.end_with?("\n")
        result
      end

      def max_lines
        @options[:max_lines]
      end
    end
  end
end
