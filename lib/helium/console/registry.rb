module Helium
  class Console
    class Registry
      class Element
        def initialize(object, **options)
          @object = object
          @options = options
        end

        attr_reader :object, :options

        def format(object, **options)
          Helium::Console.format(object, **nested_opts(options))
        end

        def format_string(string, **options)
          Helium::Console.format_string(string, **options)
        end

        def method_missing(name, *args)
          return @options[name] if @options.key?(name)
          super
        end

        def nested_opts(options)
          { level: @options[:level] + 1 }.merge(options)
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
        object.class.ancestors.each do |ancestor|
          return handlers[ancestor].new(object, **options) if handlers.key?(ancestor)
        end
        nil
      end

    private

      def handlers
        @handlers ||= {}
      end
    end
  end
end
