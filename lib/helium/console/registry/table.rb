module Helium
  class Console
    define_formatter_for Table do
      def call
        [
          *formatted_titles,
          object.runner,
          *formatted_values,
        ].compact.join($/)
      end

      def formatted_titles
        object.titles
          .flat_map(&:lines)
          .flat_map { |line| format_string(line, max_width: (max_width - 2)).lines }
          .map { |line| "# #{line}" }
      end

      def formatted_values
        key_width = object.rows.map(&:first).map(&:length).max
        object.rows.flat_map do |key, value|
          formatted_value = format(value, max_width: (max_width - key_width - indent - 4))
          formatted_value.lines.map.with_index do |line, index|
            "#{" " * indent}#{object.runner}#{index.zero? ? key.to_s.rjust(key_width) + ':' : " " * (key_width + 1)} #{line.chomp}"
          end
        end
      end
    end
  end
end
