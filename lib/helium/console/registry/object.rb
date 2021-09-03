# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for Object do
      def call
        return inline_with_truncation if force_inline?

        format_as_table
      end

      private

      def format_as_table
        table = Table.new(runner: light_black('| '), after_key: light_black(': '), format_keys: false)

        object.instance_variables.each do |inst|
          table.row(magenta(inst.to_s), object.instance_variable_get(inst))
        end

        yield_lines do |y|
          y << "#{light_black '#'} #{class_name}"
          format(table).lines.each {|line| y << line }
        end
      end

      def inline_with_truncation
        class_name = class_name(short: true)

        vars = formatted_instance_variables(max_width: 15, max_lines: 1).inject([]) do |collected, element|
          new_collected = [*collected, element]
          break collected if new_collected.join(', ').length > max_width - length_of(class_name) - 2

          new_collected
        end

        formatted_vars = "( #{vars.join(', ')} )" if vars.any?
        [class_name, formatted_vars].compact.join
      end

      def force_inline?
        level > 2
      end

      def all_symbol?
        object.keys.all? { |key| key.is_a? Symbol }
      end

      def formatted_instance_variables(**options)
        object.instance_variables.sort.each.lazy.map do |var_name|
          value = object.instance_variable_get(var_name)
          "#{magenta(var_name.to_s)} = #{format_nested(value, **options)}"
        end
      end

      def class_name(short: false)
        formatted = format(object.class, short: short)
        short ? "##{formatted}" : "#{formatted} instance"
      end
    end
  end
end
