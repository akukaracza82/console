module Helium
  class Console
    define_formatter_for NilClass do
      def call
        'nil'
      end
    end
  end
end
