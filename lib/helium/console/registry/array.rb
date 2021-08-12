# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for Array do
      def call
        return '[]' if object.none?
        return format_inline_with_truncation if force_inline?

        format_inline_with_no_truncation || format_as_table
      end

      def simple?
        object.none?
      end

      private

      def format_as_table
        table = Table.new(runner: '  ', format_keys: false)
        object.each.with_index do |element, index|
          table.row(light_black("[#{index}]:"), element)
        end

        [
          '[',
          format(table),
          ']'
        ].join("\n")
      end

      def format_inline_with_truncation
        joined = nil
        trunc = nil
        total = object.length

        object.each.with_index do |element, index|
          formatted = format_nested(element, max_lines: 1, nesting: 1, max_width: 15)

          new_joined = [joined, formatted].compact.join(' | ')
          new_trunc = (" | (#{total - index - 1} #{index.zero? ? 'elements' : 'more'})" unless index == total - 1)

          break if new_joined.length > max_width - (new_trunc&.length || 0) - 4

          joined = new_joined
          trunc = new_trunc
        end

        if joined
          joined = [' ', joined, trunc, ' '].compact.join if joined
          ['[', joined, ']'].compact.join
        else
          "[...(#{object.length})]"
        end
      end

      def format_inline_with_no_truncation
        joined = nil

        object.each do |element|
          return unless Helium::Console.simple?(element)

          formatted = format_nested(element)
          joined = [joined, formatted].compact.join(' | ')

          return if joined.length > max_width - 4
        end

        ['[', joined, ']'].compact.join(' ')
      end

      def force_inline?
        level > 2
      end
    end
  end
end
