# frozen_string_literal: true
module RSpec
  module Lint
    class Double
      class Lifetime
        include Concord.new(:doubles), Adamantium

        def unused_selectors
          defined_selectors - invoked_selectors
        end

        def unspecified_selectors
          invoked_selectors - defined_selectors
        end

        def expected_usage?
          (defined_selectors ^ invoked_selectors).empty?
        end

        def definition_location
          doubles.first.definition_location
        end

        def defined_selectors
          selector_set(&:defined_selectors)
        end
        memoize :defined_selectors

        def invoked_selectors
          selector_set(&:invoked_selectors)
        end
        memoize :invoked_selectors

        private

        def selector_set(&block)
          doubles.flat_map(&block).to_set
        end
      end
    end
  end
end
