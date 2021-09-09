# frozen_string_literal: true

require 'colorized_string'

module Helium
  class Console
    class ColorizedString < ColorizedString
      def length
        uncolorize.to_s.length
      end
    end
  end
end