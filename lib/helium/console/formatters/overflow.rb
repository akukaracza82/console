# frozen_string_literal: true

module Helium
  class Console
    module Formatters
      module Overflow
        def self.get(type)
          require "helium/console/formatters/overflow/#{type}"
          const_get(type.to_s.split('_').map(&:capitalize).join)
        rescue LoadError
          raise Error, "Unknown overflow option: #{type}"
        end
      end
    end
  end
end
