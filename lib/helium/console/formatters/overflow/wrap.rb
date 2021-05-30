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
            result = result.join($/)
            result += $/ if string.end_with?($/)
            result
          end
        end
      end
    end
  end
end
