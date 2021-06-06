module Helium
  class Console
    define_formatter_for TrueClass do
      def call
        'true'
      end
    end

    define_formatter_for FalseClass do
      def call
        'false'  
      end
    end
  end
end
