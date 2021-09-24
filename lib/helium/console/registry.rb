# frozen_string_literal: true

require 'helium/console/colorized_string'

module Helium
  class Console
    class Registry
      class Element
        class LazyStringEvaluator
          def initialize(&block)
            @lines = Enumerator.new { |y| block.(y) }
          end

          attr_reader :lines

          def to_s
            lines.to_a.join
          end
        end

        def initialize(object, console, **options)
          @object = object
          @options = options
          @console = console
        end

        def call
        end

        attr_reader :object, :options, :console

        def format_nested(other_object, **options)
          console.format(other_object, **nested_opts(options))
        end

        def format(other_object, **options)
          console.format(other_object, **nested_opts(options, increase_level: false))
        end

        def format_string(string, **options)
          console.format_string(string, **options)
        end

        def simple?
          false
        end

        ColorizedString.colors.each do |color|
          define_method color do |string|
            ColorizedString.new(string).colorize(color)
          end
        end

        def method_missing(name, *args)
          return @options[name] if @options.key?(name)

          super
        end

        def respond_to_missing?(name, private = false)
          @options.key?(name) || super
        end

        private

        def nested_objects
          []
        end

        def nested_opts(new_options, increase_level: true)
          new_options = options.merge(new_options)
          new_options[:level] += 1 if increase_level
          new_options[:ignore_objects] = nested_objects
          new_options
        end

        def length_of(string)
          ColorizedString.new(string).length
        end

        def yield_lines(&block)
          LazyStringEvaluator.new(&block)
        end
      end

      def initialize(console)
        @console = console
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
          break handlers[ancestor.name] if handlers.key?(ancestor.name)
        end
        return unless element_class

        element_class.new(object, console, **options)
      end

      private

      attr_reader :console

      def handlers
        @handlers ||= {}
      end
    end
  end
end