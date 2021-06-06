module Helium
  class Console
    define_formatter_for Numeric do
      def call
        light_cyan(object.to_s)
      end
    end
  end
end
