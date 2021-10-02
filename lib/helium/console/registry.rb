# frozen_string_literal: true

require 'helium/console/colorized_string'
require 'helium/console/formatter'

module Helium
  class Console
    class Registry
      def self.instance_formatters
        @instance_formatters ||= new
      end

      def self.class_formatters
        @class_formatters ||= new
      end

      def add(mod, formatter)
        handlers[mod] = formatter
      end

      def define(mod, &block)
        add(mod, Class.new(Formatter, &block))
      end

      def handler_for(klass)
        klass.ancestors.each do |ancestor|
          result = handlers[ancestor] || handlers[ancestor.name]
          return result if result
        end
        handlers[BasicObject]
      end

      private

      def handlers
        @handlers ||= {}
      end
    end
  end
end