# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for Method do
      def call
        as_table
      end

      private

      def as_table
        table = Table.new(runner: light_black('| '), format_keys: false, after_key: light_black(': '))
        table.row(magenta('receiver'), object.receiver)
        table.row(magenta('location'), object.source_location)

        yield_lines do |y|
          y << "#{light_black '#'} #{yellow 'method'} #{title}"
          format(table).lines.each { |line| y << line }
        end
      end

      def title
        owner = object.owner
        singleton = owner.singleton_class?

        if singleton
          owner = object.receiver
          owner = owner.ancestors.find { |ancestor| ancestor.singleton_class == object.owner } if owner.is_a? Class
        end

        formatted_owner = format(owner, short: true, max_length: 20)
        formatted_owner = "(#{formatted_owner})" unless owner.is_a? Module

        "#{formatted_owner}#{yellow(singleton ? '.' : '#')}#{yellow object.name.to_s}"
      end
    end
  end
end
