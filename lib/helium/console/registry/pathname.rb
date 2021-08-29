# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for 'Pathname' do
      def call
        "#{format(Pathname, short: true)}: #{yellow(object.to_s)}"
      end
    end
  end
end
