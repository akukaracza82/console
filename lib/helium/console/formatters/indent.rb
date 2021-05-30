module Helium
  class Console
    module Formatters
      class Indent
        def initialize(indent)
          @indent = indent
        end

        def call(string)
          string.lines.map {|line| ' ' * @indent + line }.join
        end
      end
    end
  end
end
