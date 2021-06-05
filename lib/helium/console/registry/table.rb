module Helium
  class Console
    define_formatter_for Table do
      def call
        formatted_values.join($/)
      end

      def formatted_values
        object.rows.flat_map do |key, value|
          formatted_value = format(value, max_width: max_value_width)

          formatted_value.lines.map.with_index do |line, index|
            "#{object.runner}#{index.zero? ? format_key(key).rjust(key_width) : " " * key_width}#{object.after_key}#{line.chomp}"
          end
        end
      end

      def key_width
        @key_width ||= object.rows
          .map(&:first)
          .map(&method(:format_key))
          .map(&:length).max
      end

      def max_value_width
        max_width - object.runner.length - key_width - object.after_key.length
      end

      def format_key(key)
        return key unless object.format_keys
        format(key, max_width: 15, nesting: 0)
      end
    end
  end
end
