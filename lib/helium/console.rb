require "pry"

require "helium/console/version"
require "helium/console/formatters/indent"
require "helium/console/formatters/overflow"
require "helium/console/formatters/max_lines"
require "helium/console/table"
require "helium/console/registry"
require "terminfo"

require "helium/console/printer"

module Helium
  class Console
    Error = Class.new(StandardError)

    class << self
      def instance
        @instance ||= new(registry: Registry.new)
      end

      def register(klass, &handler)
        instance.register(klass, &handler)
      end

      def format(object, **options)
        instance.format(object, **options)
      end

      def format_string(string, **options)
        instance.format_string(string, **options)
      end

      def define_formatter_for(klass, &block)
        instance.define_formatter_for(klass, &block)
      end
    end

    def initialize(registry:)
      @registry = registry
    end

    def format(object, **options)
      options = default_options.merge(options)
      handler = registry.handler_for(object, **options)

      if handler
        handler.call
      else
        format(object.inspect, **options)
      end
    end

    def register(klass, &handler)
      registry.add(klass, &handler)
    end

    def define_formatter_for(klass, &handler)
      registry.define(klass, &handler)
    end

    def default_options
      {
        overflow: :wrap,
        indent: 0,
        max_lines: nil,
        max_width: TermInfo.screen_width,
        level: 1
      }
    end

    def format_string(string, ellipses: "...", **options)
      options = default_options.merge(options)

      formatters = [
        Formatters::Overflow.get(options[:overflow]).new(max_width: options[:max_width] - options[:indent]),
        Formatters::Indent.new(options[:indent]),
        Formatters::MaxLines.new(
          max_lines: options[:max_lines],
          max_width: options[:max_width],
          ellipses: ellipses
        )
      ]

      formatters.inject(string) do |string, formatter|
        formatter.call(string)
      end
    end

  private

    attr_reader :registry
  end
end

Dir.glob(File.join(File.dirname(__FILE__), "console", "registry", "**/*.rb")).each do |file|
  require file
end
