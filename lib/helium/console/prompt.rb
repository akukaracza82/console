module Helium
  class Console
    class Prompt
      def initialize
        @line = 0
      end

      def pry_prompt
        Pry::Prompt.new(
          'helium',
          'Default prompt for helium',
          [
            method(:active_prompt),
            method(:wait_prompt)
          ]
        )
      end

      private

      def active_prompt(context, _nesting, _pry)
        @line += 1
        str = [
          ColorizedString.new("[#{@line}]").light_black,
          ColorizedString.new("He\u269B").light_blue,
          ColorizedString.new("(#{context.inspect})").magenta
        ].join(' ')
        "#{str}> "
      end

      def wait_prompt(context, nesting, pry)
        @line += 1
        str = [
          ColorizedString.new("[#{@line}]").light_black,
          '   ',
          ColorizedString.new("(#{context.inspect})").magenta
        ].join(' ')
        "#{str}> "
      end
    end
  end
end