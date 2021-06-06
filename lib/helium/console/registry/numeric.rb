module Helium
  class Console
    define_formatter_for Numeric do
      def call
        object.to_s
      end
    end
  end
end
