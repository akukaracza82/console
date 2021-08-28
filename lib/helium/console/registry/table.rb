# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for Table do
      def call
        [
          *formatted_values,
          truncation
        ].compact.join("\n")
      end

      private

      def formatted_values
        rows.flat_map do |key, value, options = {}|
          format_pair(key, value, **options)
        end
      end

      def format_pair(key, value, **options)
        formatted_value = format_nested(value, max_width: max_value_width, **options)

        formatted_value.lines.map.with_index do |line, index|
          [
            object.runner,
            text_or_blank(rjust(format_key(key), key_width), blank: index > 0),
            text_or_blank(object.after_key, blank: index > 0),
            line.chomp
          ].join
        end
      end

      def text_or_blank(text, blank:)
        return text unless blank

        ' ' * length_of(text)
      end

      def key_width
        @key_width ||= rows
          .map(&:first)
          .map(&method(:format_key))
          .map(&method(:length_of))
          .max
      end

      def max_value_width
        max_width - length_of(object.runner) - key_width - length_of(object.after_key)
      end

      def format_key(key)
        object.format_keys ? format(key, max_width: 15, level: 3) : key
      end

      def rjust(string, width)
        ' ' * (width - length_of(string)) + string
      end

      def rows
        @rows ||= case level
          when 1 then rows_limited_by(42)
          when 2 then rows_limited_by(10)
          else rows_limited_by(3)
        end
      end

      def rows_limited_by(number)
        object.rows.count <= number ? object.rows : object.rows.first(number - 1)
      end

      def truncation
        return unless object.rows.length > rows.length

        [
          object.runner,
          light_black("(#{object.rows.length - rows.length} more)")
        ].join
      end
    end
  end
end
