# frozen_string_literal: true

module Helium
  class Console
    define_class_formatter_for BasicObject do
      def render_compact
        class_name || singleton_name || anonymous_text
      end

      private

      def class_name
        light_yellow(object.name) if object.name
      end

      def singleton_name
        return unless object.is_a?(Class) && object.singleton_class?

        owner = ObjectSpace.each_object(object).first
        "#{light_yellow 'singleton class of'} #{format owner, :compact}"
      end

      def anonymous_text
        closest = (object.ancestors.grep(Class) - [Object, BasicObject]).find(&:name)&.name

        signature = if closest
          "#{light_yellow 'subclass of'} #{format closest, :compact}"
        else
          light_yellow(object.class.name.downcase)
        end

        "#{light_yellow '('}#{signature})#{light_yellow ')'}"
      end
    end
  end
end
