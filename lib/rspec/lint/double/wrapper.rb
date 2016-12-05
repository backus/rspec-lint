# frozen_string_literal: true

module RSpec
  module Lint
    class Double
      class Wrapper < SimpleDelegator
        include Concord.new(:recorder)

        def __id__
          __getobj__.__id__
        end

        def initialize(recorder, target)
          super(recorder)
          __setobj__(target)
        end

        private

        # :reek:ManualDispatch
        def respond_to_missing?(*arguments)
          __getobj__.respond_to?(*arguments)
        end

        def method_missing(method_name, *args, &block)
          recorder.record(method_name, args, block)
          super
        end
      end
    end
  end
end
