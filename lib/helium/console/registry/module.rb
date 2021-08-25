# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for Module do
      def call
        light_yellow(object.name || anonymous_text)
      end

      private

      def anonymous_text
        closest = (object.ancestors.grep(Class) - [Object, BasicObject]).find(&:name)&.name

        signature = if closest
          "subclass of #{closest}"
        else
          object.class.name.downcase
        end
        "(anonymous #{signature})"
      end
    end
  end
end
