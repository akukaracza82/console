# frozen_string_literal: true

module Helium
  class Console
    class Table
      def initialize(runner: '|', after_key: ' ', format_keys: true)
        @runner = runner
        @after_key = after_key
        @format_keys = format_keys
      end

      attr_reader :runner, :after_key, :format_keys

      def row(key, value, style = nil, **options)
        rows << [key, value, style, options]
      end

      def rows
        @rows ||= []
      end
    end
  end
end
