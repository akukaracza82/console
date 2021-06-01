module Helium
  class Console
    define_formatter_for Array do
      def call
        return format_inline_with_truncation if force_inline?
        format_inline_with_no_truncation || format_as_table
      end

    private

      def format_as_table
        table = Table.new(runner: '. ', format_keys: false)
        object.each.with_index do |element, index|
          table.row("[#{index}]:", element)
        end

        [
          "[",
          format(table, **options),
          "]"
        ].join($/)
      end

      def format_inline_with_truncation
        joined = nil
        trunc = nil
        total = object.length

        object.each.with_index do |element, index|
          formatted = format(element, max_lines: 1, nesting: 1, max_width: 15)

          new_joined = [joined, formatted].compact.join(" | ")
          new_trunc = (" | (#{total - index - 1} #{index.zero? ? 'elements' : 'more'})" unless index == total - 1)

          break if new_joined.length > max_width - (new_trunc&.length || 0) - 4

          joined = new_joined
          trunc = new_trunc
        end

        if joined
          joined = [" ", joined, trunc, " "].compact.join if joined
          ["[", joined, "]"].compact.join
        else
          "[...(#{object.length})]"
        end
      end

      def format_inline_with_no_truncation
        joined = nil
        one_complex = false

        object.each do |element|
          if element.inspect.lines.count > 1
            return if one_complex
            one_complex = true
          end

          formatted = format(element)
          joined = [joined, formatted].compact.join(" | ")

          return if joined.length > max_width - 4
        end
        joined = " #{joined} " if joined
        ["[", joined, "]"].compact.join
      end

      def force_inline?
        (max_lines && max_lines < 5) || nesting < 2
      end
    end
  end
end
