module Helium
  class Console
    define_formatter_for Array do
      def call
        formatted_objects = object.map { |elem| format(elem, max_width: (max_width - 1), indent: 2) }
        ["[", formatted_objects.join(",#{$/}"), "]"].join($/)
      end
    end
  end
end
