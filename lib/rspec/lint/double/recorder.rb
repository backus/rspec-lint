# frozen_string_literal: true
module RSpec
  module Lint
    class Double
      class Recorder
        include Concord.new(:invocations)

        def initialize
          super([])
        end

        def record(selector, arguments, block)
          invocations <<
            MethodInvocation.new(
              selector:  selector,
              arguments: arguments,
              block:     block
            )
        end

        def invoked_selectors
          invocations.map(&:selector)
        end

        def history
          invocations.freeze
        end

        class MethodInvocation
          include Anima.new(:selector, :arguments, :block), Adamantium
        end
      end
    end
  end
end
