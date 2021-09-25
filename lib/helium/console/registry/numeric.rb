# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for Numeric do
      def render_compact
        light_cyan(object.to_s)
      end
    end
  end
end
