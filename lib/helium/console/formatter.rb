# frozen_string_literal: true

module Helium
  class Console
    class Formatter
      DEFAULT_STYLES = {
        1 => [:full, {}],
        2 => [:partial, {}],
        3 => [:partial, { max_lines: 1 }]
      }.freeze

      class LazyStringEvaluator
        def initialize(&block)
          @lines = Enumerator.new { |y| block.(y) }
        end

        attr_reader :lines

        def to_s
          lines.to_a.join
        end
      end

      def initialize(object, style, console, **options)
        @object = object
        @options = options
        @style = style
        @console = console
      end

      def call
        method_name = [:render, @style].compact.join('_')
        public_send(method_name)
      end

      def optimal_format
        DEFAULT_STYLES.fetch(level) { [:compact, {}] }
      end

      def render
        format(object, *optimal_format)
      end

      def render_full
        render_partial
      end

      def render_partial
        format_string(render_inline, max_width: max_width, indent: indent)
      end

      def render_inline
        render_compact
      end

      def render_compact
        raise NotImplementedError
      end

      attr_reader :object, :options

      def format_nested(other_object, style = nil, **options)
        @console.format(other_object, style, **nested_opts(options))
      end

      def format(other_object, style = nil, **options)
        @console.format(other_object, style, **nested_opts(options, increase_level: false))
      end

      def format_string(string, **options)
        @console.format_string(string, **options)
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
  end
end