# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for Hash do
      def call
        return '{}' if object.none?
        return inline_with_truncation if force_inline?

        inline_without_truncation || format_as_table
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

      def inline_with_truncation
        truncated = formatted_inline_elements.with_index.inject([]) do |collected, (formatted, index)|
          new_collected = [*collected[0..-2], formatted, trunc_text(index + 1)].compact
          break collected if new_collected.join(', ').length > max_width - 4

          new_collected
        end

        ['{ ', truncated.join(', '), ' }'].compact.join
      end

      def inline_without_truncation
        formatted = formatted_inline_elements.inject([]) do |collected, element|
          collected << element
          break if collected.join(', ').length > max_width - 4

          collected
        end

        return if formatted.nil?

        ['{ ', formatted.join(', '), ' }'].compact.join
      end

      def force_inline?
        level > 2
      end

      def formatted_inline_elements
        object.each.lazy.map do |key, value|
          formatted_key = format_key(key, max_lines: 1, nesting: 1, max_with: 15)
          formatted_value = format_nested(value, max_lines: 1, nesting: 1, max_width: 15)
          [formatted_key, after_key, formatted_value].join
        end
      end

      def all_symbol?
        object.keys.all? { |key| key.is_a? Symbol }
      end

      def format_key(key, **options)
        return light_blue(key.to_s) if all_symbol?

        format_nested(key, **options)
      end

      def total_elements
        @total_elements ||= object.length
      end

      def trunc_text(count)
        truncated_elements = total_elements - count
        light_black("(#{truncated_elements} #{count.zero? ? 'elements' : 'more'})")
      end

      def after_key
        all_symbol? ? light_blue(': ') : light_black(' => ')
      end
    end
  end
end
