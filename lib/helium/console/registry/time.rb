# frozen_string_literal: true

module Helium
  class Console
    define_formatter_for Time do
      def call
        green object.strftime("%A, %d %b %Y, %H:%M:%S")
      end
    end
  end
end
