require "helium/console/version"

require "helium/console/formatters/indent"
require "helium/console/formatters/overflow"
require "helium/console/formatters/max_lines"
require "terminfo"

module Helium
  module Console
    Error = Class.new(StandardError)

    class << self
      def format(text, overflow: :wrap, indent: 0, max_lines: nil, max_width: TermInfo.screen_width)
        formatters = [
          Formatters::Overflow.get(overflow).new(max_width: max_width - indent),
          Formatters::Indent.new(indent),
          Formatters::MaxLines.new(max_lines: max_lines, max_width: max_width)
        ]

        formatters.inject(text) do |text, formatter|
          formatter.call(text)
        end
      end
    end
  end
end
