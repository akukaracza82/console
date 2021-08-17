# frozen_string_literal: true

require 'pry'

require 'helium/console/version'
require 'helium/console/formatters/indent'
require 'helium/console/formatters/overflow'
require 'helium/console/formatters/max_lines'
require 'helium/console/table'
require 'helium/console/registry'

require 'helium/console/printer'

module Helium
  class Console
    Error = Class.new(StandardError)

    SIMPLE_OBJECTS = [
      Numeric,
      NilClass,
      FalseClass,
      TrueClass,
      Symbol
    ].freeze

    class << self
      def instance
        @instance ||= new(registry: Registry.new)
      end

      def method_missing(name, *args, &block)
        super unless instance.respond_to?(name)

        instance.public_send(name, *args, &block)
      end

      def respond_to_missing?(name, private = false)
        instance.respond_to?(name) || super
      end
    end

    def initialize(registry:)
      @registry = registry
    end

    def format(object, **options)
      options = default_options.merge(options)
      return '(...)' if options[:ignore_objects].include?(object.object_id)

      handler = registry.handler_for(object, **options)

      if handler
        handler.()
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

    def simple?(object)
      SIMPLE_OBJECTS.any? { |simple_obj_class| object.is_a? simple_obj_class } ||
        registry.handler_for(object).simple?
    end

    def default_options
      {
        overflow: :wrap,
        indent: 0,
        max_width: `tput cols`.chomp.to_i,
        level: 1,
        ignore_objects: []
      }
    end

    def format_string(string, ellipses: '...', **options)
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

      formatters.inject(string) do |str, formatter|
        formatter.(str)
      end
    end

    private

    attr_reader :registry
  end
end

Dir.glob(File.join(File.dirname(__FILE__), 'console', 'registry', '**/*.rb')).sort.each do |file|
  require file
end
