module Helium
  class Console
    define_formatter_for Table do
      def call
        formatted_values.join($/)
      end

      def formatted_values
        object.rows.flat_map do |key, value|
          formatted_value = format_nested(value, max_width: max_value_width)

          formatted_value.lines.map.with_index do |line, index|
            [
              object.runner,
              index.zero? ? format_key(key).rjust(key_width) : " " * key_width,
              index.zero? ? object.after_key : " " * length_of(object.after_key),
              line.chomp,
            ].join
          end
        end
      end

      def key_width
        @key_width ||= object.rows
          .map(&:first)
          .map(&method(:format_key))
          .map(&method(:length_of))
          .max
      end

      def max_value_width
        max_width - length_of(object.runner) - key_width - length_of(object.after_key)
      end

      def format_key(key)
        return key unless object.format_keys
        format(key, max_width: 15, level: 3)
      end

      def length_of(string)
        if string.respond_to?(:uncolorize)
          string.uncolorize.length
        else
          string.length
        end
      end
    end
  end
end
