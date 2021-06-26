module Helium
  class Console
    define_formatter_for Module do
      def call
        light_yellow(object.name || anonymus_text)
      end

      private

      def anonymus_text
        closest = object.ancestors.find(&:name).name
        "(anonymous #{closest})"
      end
    end
  end
end
