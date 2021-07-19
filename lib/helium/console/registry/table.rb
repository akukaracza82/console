module Helium
  class Console
    define_formatter_for Table do
      def call
        [
          *formatted_values,
          truncation,
        ].compact.join($/)
      end

      def formatted_values
        rows.flat_map do |key, value, options = {}|
          formatted_value = format_nested(value, max_width: max_value_width, **options)

          formatted_value.lines.map.with_index do |line, index|
            [
              object.runner,
              index.zero? ? rjust(format_key(key), key_width) : " " * key_width,
              index.zero? ? object.after_key : " " * length_of(object.after_key),
              line.chomp,
            ].join
          end
        end
      end

      def truncation
        return unless object.rows.length > rows.length

        [
          object.runner,
          light_black("(#{object.rows.length - rows.length} more)")
        ].join
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
        " " * (width - length_of(string)) + string
      end

      def length_of(string)
        if string.respond_to?(:uncolorize)
          string.uncolorize.length
        else
          string.length
        end
      end

      def rows
        @rows ||= case level
        when 1 then object.rows
        when 2
          object.rows.count < 10 ? object.rows : object.rows.first(9)
        else
          object.rows.count < 3 ? object.rows : object.rows.first(2)
        end
      end
    end
  end
end
