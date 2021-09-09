# frozen_string_literal: true

require 'colorized_string'

module Helium
  class Console
    class ColorizedString < ColorizedString
      def length
        uncolorize.to_s.length
      end

      def colorize(*)
        return self unless Pry.color

        super
      end
    end
  end
end