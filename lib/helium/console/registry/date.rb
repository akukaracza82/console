# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for 'Date' do
      def call
        blue object.strftime('%A, %d %b %Y')
      end
    end
  end
end
