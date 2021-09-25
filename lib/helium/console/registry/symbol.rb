# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for Symbol do
      def render_compact
        light_blue(":#{object}")
      end
    end
  end
end
