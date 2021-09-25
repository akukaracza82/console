# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for NilClass do
      def render_compact
        light_black('nil')
      end
    end
  end
end
