# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for TrueClass do
      def call
        green('true')
      end
    end

    define_formatter_for FalseClass do
      def call
        red('false')
      end
    end
  end
end
