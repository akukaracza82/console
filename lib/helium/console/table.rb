module Helium
  class Console
    class Table

      def initialize(runner: "|", header_mark: "#")
        @runner = runner
        @header_mark = header_mark
      end

      attr_reader :runner, :header_mark

      def title(title)
        titles << title
      end

      def row(key, value)
        rows << [key, value]
      end

      def titles
        @titles ||= []
      end

      def rows
        @rows ||= []
      end
    end
  end
end
