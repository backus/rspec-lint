# frozen_string_literal: true
module RSpec
  module Lint
    class Let < Module
      attr_reader :definitions

      def initialize
        @definitions = {}
      end

      def extended(klass)
        klass.instance_exec(self) do |hijacker|
          define_singleton_method(:hijacker) { hijacker }

          extend Mixin
        end
      end

      def add(definition, name)
        definitions[definition] = name
      end

      def remove(definition)
        definitions.delete(definition)
      end

      module Mixin
        def let(name)
          definition = caller.first
          hijack = hijacker
          hijacker.add(definition, name)

          super

          wrapper =
            Module.new do
              define_method(name) do
                hijack.remove(definition)

                super()
              end
            end

          prepend(wrapper)
        end
      end
    end
  end
end
