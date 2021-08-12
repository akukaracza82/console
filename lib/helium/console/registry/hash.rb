# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for Hash do
      def call
        return format_inline_with_truncation if force_inline?

        format_inline_with_no_truncation || format_as_table
      end

      private

      def format_as_table
        table = Table.new(runner: '  ', after_key: after_key, format_keys: !all_symbol?)
        object.each do |key, value|
          key = light_blue(key.to_s) if all_symbol?
          table.row(key, value)
        end

        [
          '{',
          format(table, **options),
          '}'
        ].join("\n")
      end

      def format_inline_with_truncation
        joined = nil
        trunc = nil
        total = object.length

        object.each.with_index do |(key, value), index|
          formatted_key = format(key, max_lines: 1, nesting: 1, max_with: 15)
          formatted_value = format(value, max_lines: 1, nesting: 1, max_width: 15)

          formatted = "#{formatted_key} => #{formatted_value}"

          new_joined = [joined, formatted].compact.join(', ')
          new_trunc = (", (#{total - index - 1} #{index.zero? ? 'elements' : 'more'})" unless index == total - 1)

          break if new_joined.length > max_width - (new_trunc&.length || 0) - 4

          joined = new_joined
          trunc = new_trunc
        end

        joined = [' ', joined, trunc, ' '].compact.join if joined
        ['{', joined, '}'].compact.join
      end

      def format_inline_with_no_truncation
        joined = nil
        one_complex = false

        object.each do |key, value|
          return unless simple?(value)

          formatted_key = format(key, max_lines: 1, nesting: 1, max_with: 15)
          formatted_value = format(value, max_lines: 1, nesting: 1, max_width: 15)
          formatted = "#{formatted_key} => #{formatted_value}"

          joined = [joined, formatted].compact.join(', ')

          return if joined.length > max_width - 4
        end
        joined = " #{joined} " if joined
        ['{', joined, '}'].compact.join
      end

      def force_inline?
        level > 2
      end

      def all_symbol?
        object.keys.all? { |key| key.is_a? Symbol }
      end

      def after_key
        all_symbol? ? light_blue(': ') : light_black(' => ')
      end
    end
  end
end
