# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for TrueClass do
      def render_compact
        green('true')
      end
    end

    define_formatter_for FalseClass do
      def render_compact
        red('false')
      end
    end
  end
end
