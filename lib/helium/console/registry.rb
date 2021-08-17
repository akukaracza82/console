# frozen_string_literal: true

require 'colorized_string'

module Helium
  class Console
    class Registry
      class Element
        def initialize(object, **options)
          @object = object
          @options = options
        end

        def call
        end

        attr_reader :object, :options

        def format_nested(other_object, **options)
          Helium::Console.format(other_object, **nested_opts(options))
        end

        def format(other_object, **options)
          Helium::Console.format(other_object, **nested_opts(options, increase_level: false))
        end

        def format_string(string, **options)
          Helium::Console.format_string(string, **options)
        end

        def simple?
          false
        end

        def method_missing(name, *args)
          return @options[name] if @options.key?(name)
          return ColorizedString.new(*args).colorize(name) if ColorizedString.colors.include?(name)

          super
        end

        def respond_to_missing?(name, private = false)
          @options.key?(name) || ColorizedString.colors.include?(name) || super
        end

        def nested_opts(new_options, increase_level: true)
          new_options = options.merge(new_options)
          new_options[:level] += 1 if increase_level
          new_options[:ignore_objects] << object.object_id
          new_options
        end

        def length_of(string)
          if string.respond_to?(:uncolorize)
            string.uncolorize.length
          else
            string.length
          end
        end
      end

      def add(klass, &handler)
        define(klass) do
          define_method(:call, &handler)
        end
      end

      def define(klass, &block)
        handlers[klass] = Class.new(Element, &block)
      end

      def handler_for(object, **options)
        element_class = object.class.ancestors.find do |ancestor|
          break handlers[ancestor] if handlers.key?(ancestor)
        end
        return unless element_class

        element_class.new(object, **options)
      end

      private

      def handlers
        @handlers ||= {}
      end
    end
  end
end
