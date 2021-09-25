# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for Table do
      def call
        yield_lines do |y|
          rows.each do |key, value, style, options = {}|
            format_pair(key, value, style, **options) do |line|
              y << line
            end
          end
          y << truncation if truncation
        end
      end

      private

      def format_pair(key, value, style, **options)
        formatted_value = format_nested(value, style, max_width: max_value_width, **options)

        formatted_value.lines.each.with_index.map do |line, index|
          yield [
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
          when 1 then object.rows
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
          light_black("(#{object.rows.length - rows.length} more)"),
          "\n"
        ].join
      end
    end
  end
end
