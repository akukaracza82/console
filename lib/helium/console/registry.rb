module Helium
  class Console
    class Registry
      class Element
        def initialize(object, **options)
          @object = object
          @options = options
        end

        attr_reader :object

        def format(object, **options)
          Helium::Console.format(object, **options)
        end

        def method_missing(name, *args)
          return @options[name] if @options.key?(name)
          super
        end
      end

      def add(klass, &handler)
        define(klass) do
          define_method(:call, &handler)
        end
      end

      def define(klass, &block)
        klass.prepend(Inspectable)
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
