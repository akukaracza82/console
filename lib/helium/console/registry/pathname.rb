# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for 'Pathname' do
      def render_compact
        "#{format(Pathname, :compact)}: #{yellow(object.to_s)}"
      end
    end
  end
end
