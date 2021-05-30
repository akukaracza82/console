module Helium
  class Console
    define_formatter_for Array do
      def call
        table = Table.new(runner: nil)
        object.each.with_index do |element, index|
          table.row("[#{index}]", element)
        end

        [
          "[",
          format(table, options.merge(indent: 2)),
          "]"
        ].join($/)
      end
    end
  end
end
