# frozen_string_literal: true

require 'pry'

require 'helium/console/version'
require 'helium/console/formatters/indent'
require 'helium/console/formatters/overflow'
require 'helium/console/formatters/max_lines'
require 'helium/console/table'
require 'helium/console/registry'

require 'helium/console/printer'
require 'helium/console/prompt'

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

    def self.start(target = nil, options = {})
      prompt = ColorizedString.new("He\u269B").light_blue
      line = 0

      options = {
        print: ColorPrinter.method(:default),
        prompt: Prompt.new.pry_prompt
      }.merge(options)

      Pry.start(target, options)
    end

    def self.define_formatter_for(klass, &handler)
      Registry.instance_formatters.define(klass, &handler)
    end

    def self.define_class_formatter_for(klass, &handler)
      Registry.class_formatters.define(klass, &handler)
    end


    class << self
      def instance
        @instance ||= new
      end

      def method_missing(name, *args, &block)
        super unless instance.respond_to?(name)

        instance.public_send(name, *args, &block)
      end

      def respond_to_missing?(name, private = false)
        instance.respond_to?(name) || super
      end
    end

    def format(object, style = nil, **options)
      options = default_options.merge(options)
      return '(...)' if options[:ignore_objects].include?(object.object_id)

      handler_for(object, style, **options).()
    end

    def simple?(object, style = nil, **options)
      SIMPLE_OBJECTS.any? { |simple_obj_class| object.is_a? simple_obj_class } ||
        handler_for(object, style, **options).simple?
    end

    def default_options
      {
        overflow: :wrap,
        indent: 0,
        level: 1,
        ignore_objects: [],
        short: false
      }
    end

    def format_string(string, ellipses: '...', **options)
      options = default_options.merge(options)
      formatters = [
        Formatters::Indent.new(options[:indent]),
        Formatters::MaxLines.new(
          max_lines: options[:max_lines],
          max_width: options[:max_width],
          ellipses: ellipses
        )
      ]
      if options[:max_width]
        formatters.unshift(
          Formatters::Overflow.get(options[:overflow]).new(max_width: options[:max_width] - options[:indent]),
        )
      end

      formatters.inject(string) do |str, formatter|
        formatter.(str)
      end
    end

    private

    # TODO: Injection instead of hard dependency!
    def handler_for(object, style, **options)
      formatter_class = if object.is_a? Module
        Registry.class_formatters.handler_for(object)
      else
        Registry.instance_formatters.handler_for(object.class)
      end
      formatter_class&.new(object, style, self, **options)
    end
  end
end

Dir.glob(File.join(File.dirname(__FILE__), 'console', 'registry', '**/*.rb')).sort.each do |file|
  require file
end
