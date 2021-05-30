
module Helium
  class Console
    module Formatters
      module Overflow
        def self.get(type)
          require "helium/console/formatters/overflow/#{type}"
          const_get(type.to_s.split('_').map(&:capitalize).join)
        rescue
          raise Error.new("Unknown overflow option: #{type}")
        end
      end
    end
  end
end
