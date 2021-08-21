# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for Array do
      def call
        return '[]' if object.none?
        return inline_with_truncation if force_inline?

        inline_without_truncation || format_as_table
      end

      def simple?
        object.none?
      end

      private

      def format_as_table
        table = Table.new(runner: '  ', format_keys: false)
        object.each.with_index do |element, index|
          table.row(light_black("[#{index}]:"), element)
        end

        [
          '[',
          format(table),
          ']'
        ].join("\n")
      end

      def inline_with_truncation
        formatted = formatted_elements.with_index.inject([]) do |joined, (element, index)|
          new_joined = [*joined[0..-2], element, trunc_message(object_size - index - 1, all_truncated: index.zero?)]
          break joined if too_long?(new_joined, max_width: max_width - 4)

          new_joined
        end

        "[ #{formatted.compact.join(' | ')} ]"
      end

      def inline_without_truncation
        return unless object.all? { |element| Helium::Console.simple? element }

        formatted = formatted_elements.inject([]) do |joined, element|
          joined = [*joined, element]
          break if too_long?(joined, max_width: max_width - 4)

          joined
        end

        "[ #{formatted.join(' | ')} ]" unless formatted.nil?
      end

      def too_long?(object, max_width:)
        string = object.respond_to?(:join) ? object.join(' | ') : object
        length_of(string) > max_width - 4
      end

      def formatted_elements(**options)
        object.each.lazy.map { |element| format_nested(element, **options) }
      end

      def trunc_message(count, all_truncated: false)
        return if count < 1

        "(#{count} #{all_truncated ? 'elements' : 'more'})"
      end

      def object_size
        @object_size ||= object.size
      end

      def force_inline?
        level > 2
      end
    end
  end
end
