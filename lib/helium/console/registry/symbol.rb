module Helium
  class Console
    define_formatter_for Symbol do
      def call
        ':' + object.to_s
      end
    end
  end
end
