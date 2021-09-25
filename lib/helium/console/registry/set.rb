# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for Set do
      def render_compact
        return rendr_empty if object.none?

        "#{light_magenta('Set:')} #{trunc_message(object.count, all_truncated: true)}"
      end

      def render_partial
        return "#{light_magenta('Set:')} #{red 'empty'}" if object.none?
        return inline_with_truncation if options[:max_lines] == 1

        inline_without_truncation || format_as_table
      end

      def simple?
        object.none?
      end

      private

      def render_empty
        "#{light_magenta('Set:')} #{red 'empty'}" if object.none?
      end

      def format_as_table
        table = Table.new(runner: '', format_keys: false)
        object.each do |element|
          table.row(light_black('-'), element)
        end

        yield_lines do |y|
          y << light_magenta('Set: {')
          format(table).lines.each { |line| y << line }
          y << light_magenta('}')
        end
      end

      def inline_with_truncation
        formatted = formatted_elements.with_index.inject([]) do |joined, (element, index)|
          new_joined = [*joined[0..-2], element, trunc_message(object_size - index - 1, all_truncated: index.zero?)]
          break joined if too_long?(new_joined, max_width: max_width - 9)

          new_joined
        end

        "#{light_magenta('Set: {')} #{formatted.join(light_magenta(' | '))} #{light_magenta('}')}"
      end

      def inline_without_truncation
        return unless object.all? { |element| Helium::Console.simple? element }

        formatted = formatted_elements.inject([]) do |joined, element|
          joined = [*joined, element]
          break if too_long?(joined, max_width: max_width - 4)

          joined
        end

        "#{light_magenta('Set: {')} #{formatted.join(light_magenta(' | '))} #{light_magenta('}')}" unless formatted.nil?
      end

      def too_long?(object, max_width:)
        string = object.respond_to?(:join) ? object.join(' | ') : object
        length_of(string) > max_width - 4
      end

      def formatted_elements(**options)
        sorted = object.sort rescue object
        sorted.each.lazy.map { |element| format_nested(element, **options) }
      end

      def trunc_message(count, all_truncated: false)
        return if count < 1

        light_black "(#{count} #{all_truncated ? 'elements' : 'more'})"
      end

      def object_size
        @object_size ||= object.size
      end
    end
  end
end
