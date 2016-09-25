# frozen_string_literal: true
module RSpec
  module Lint
    class Double
      include Anima.new(:definition, :recorder, :stack, :original)

      def definition_location
        SourceLocation.new(stack.first.path, stack.first.lineno)
      end

      def wrapper
        Wrapper.new(recorder, original)
      end

      def invoked_selectors
        recorder.invoked_selectors
      end

      def defined_selectors
        method_double_arguments.keys
      end

      private

      def method_double_arguments
        last_argument = definition.last
        return last_argument if last_argument.instance_of?(Hash)

        {}
      end

      class SourceLocation
        include Concord.new(:path, :line)

        def to_s
          "#{path}:#{line}"
        end
      end
    end
  end
end
