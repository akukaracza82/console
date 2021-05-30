module Helium
  class Console
    module Formatters
      class MaxLines
        ELLIPSES = "...\""

        def initialize(max_lines:, max_width:, ellipses:)
          @max_lines = max_lines
          @max_width = max_width
          @ellipses = ellipses
        end

        def call(string)
          return string if !@max_lines || string.lines.count <= @max_lines

          lines = string.lines.first(@max_lines)
          last_line = lines.pop
          lines << last_line.chars.first(@max_width - @ellipses.length).join + @ellipses
          lines.join()
        end
      end
    end
  end
end
