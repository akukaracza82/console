module Helium
  class Console
    module Inspectable
      def inspect
        if caller.grep(/:in `inspect'/).count.zero?
          $/ + Helium::Console.format(self)
        else
          Helium::Console.format(self, max_lines: 1, max_width: 25)
        end
      end
    end
  end
end
