# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for 'Date' do
      def render_inline
        blue object.strftime('%A, %d %b %Y')
      end

      def render_comapact
        blue object.strftime('%d/%m/%Y')
      end
    end
  end
end
