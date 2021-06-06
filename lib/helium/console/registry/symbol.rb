module Helium
  class Console
    define_formatter_for Symbol do
      def call
        light_blue(':' + object.to_s)
      end
    end
  end
end
