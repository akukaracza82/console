module Helium
  class Console
    module Inspectable
      def inspect
        $/ + Helium::Console.format(self)
      end
    end
  end
end
