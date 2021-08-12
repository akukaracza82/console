# frozen_string_literal: true

module Helium
  class Console
    module Formatters
      module Overflow
        class Wrap
          def initialize(max_width:)
            @max_width = max_width
          end

          def call(string)
            result = string.lines.flat_map do |line|
              line.chomp.chars.each_slice(@max_width).map(&:join)
            end
            result = result.join("\n")
            result += "\n" if string.end_with?("\n")
            result
          end
        end
      end
    end
  end
end
