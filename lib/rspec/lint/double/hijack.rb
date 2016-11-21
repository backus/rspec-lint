# frozen_string_literal: true
module RSpec
  module Lint
    class Double
      class Hijack < Module
        include Concord.new(:history)

        def included(klass)
          klass.instance_exec(self) do |double_hijack|
            private define_method(:double_hijack) { double_hijack }

            prepend Mixin
          end
        end

        def mismatched_definitions(&block)
          improperly_used_doubles.each(&block)
        end

        def wrap_double(original, args, stack)
          linted_double = Double.new(
            definition: args,
            recorder:   Recorder.new,
            stack:      stack,
            original:   original
          )

          history.add(linted_double)

          linted_double.wrapper
        end

        private

        def improperly_used_doubles
          history.doubles.reject(&:expected_usage?)
        end

        class History
          include Concord.new(:double_instances)

          def add(linted_double)
            double_instances << linted_double
          end

          def doubles
            double_instances.group_by(&:definition_location).map do |_, instances|
              Lifetime.new(instances)
            end
          end
        end

        module Mixin
          def self.hijack(method_name)
            define_method(method_name) do |*args|
              double_hijack.wrap_double(super(*args), args, caller_locations)
            end
          end

          def self.spy_workaround(spy_method, double_method)
            define_method(spy_method) do |*args|
              method(double_method).super_method.call(*args).as_null_object
            end
          end

          hijack :double
          hijack :instance_double
          hijack :class_double
          hijack :object_double

          spy_workaround :spy, :double
          spy_workaround :instance_spy, :instance_double
          spy_workaround :class_spy, :class_double
          spy_workaround :object_spy, :object_double
        end
      end
    end
  end
end
