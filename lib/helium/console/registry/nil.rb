module Helium
  class Console
    define_formatter_for NilClass do
      def call
        light_black('nil')
      end
    end
  end
end
