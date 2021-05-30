module Helium
  class Console
    register Object do
      formatters = [
        Formatters::Overflow.get(overflow).new(max_width: max_width - indent),
        Formatters::Indent.new(indent),
        Formatters::MaxLines.new(max_lines: max_lines, max_width: max_width, ellipses: "...")
      ]

      formatters.inject(object.inspect) do |string, formatter|
        formatter.call(string)
      end
    end
  end
end
