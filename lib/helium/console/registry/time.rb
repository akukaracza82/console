# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for Time do
      def render_inline
        blue object.strftime('%A, %d %b %Y, %H:%M:%S')
      end

      def render_compact
        blue object.strftime('%d/%m/%Y, %H:%M')
      end
    end
  end
end
