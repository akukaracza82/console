# frozen_string_literal: true

module Helium
  class Console
    define_class_formatter_for BasicObject do
      def render_compact
        light_yellow(object.name || singleton_name || anonymous_text)
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

      def singleton_name
        return unless object.is_a?(Class) && object.singleton_class?

        owner = ObjectSpace.each_object(object).first
        "singleton class of #{format owner, :compact}"
      end
    end
  end
end
