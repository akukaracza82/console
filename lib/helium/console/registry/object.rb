module Helium
  class Console
    define_formatter_for Object do
      def call
        return format_inline_with_truncation if force_inline?
        format_as_table
      end

    private

      def format_as_table
        table = Table.new(runner: light_black('| '), after_key: light_black(": "), format_keys: false)

        object.instance_variables.each do |inst|
          table.row(magenta(inst.to_s), object.instance_variable_get(inst))
        end

        [
          table_header,
          format(table),
        ].reject(&:empty?).join($/)
      end

      def format_inline_with_truncation
        "#{object.class.name}##{object.object_id.to_s(16)}"
      end

      def format_inline_with_no_truncation
        joined = nil

        object.each do |key, value|
          return unless simple?(value)

          formatted_key = format(key, level: 3, max_with: 15)
          formatted_value = format(value, level: 3, max_width: 15)
          formatted = "#{formatted_key} => #{formatted_value}"

          joined = [joined, formatted].compact.join(", ")

          return if joined.length > max_width - 4
        end
        joined = " #{joined} " if joined
        ["{", joined, "}"].compact.join
      end

      def table_header
        type = case object
          when Class then :class
          when Module then :module
          else :instance
        end
        klass = type == :instance ? object.class : object
        klass_name = klass.name
        if !klass_name
          named_ancestor = klass.ancestors.find(&:name)
          klass_name = ['anonymous', named_ancestor&.name].compact.join(" ")
        end
        "#{light_black('#')} #{light_yellow(klass_name)} #{type}"
      end

      def force_inline?
        level > 2
      end

      def all_symbol?
        object.keys.all? { |key| key.is_a? Symbol }
      end
    end
  end
end
