# frozen_string_literal: true

RSpec.describe RSpec::Lint::Double::Hijack do
  subject(:hijack) do
    described_class.new(described_class::History.new([unused, undefined, correct]))
  end

  let(:args)     { double(:arguments)                             }
  let(:original) { double(:original)                              }
  let(:stack)    { [instance_double(Thread::Backtrace::Location)] }

  let(:unused) do
    instance_double(
      RSpec::Lint::Double,
      invoked_selectors:   [],
      defined_selectors:   %i[a],
      definition_location: '/src/one.rb'
    )
  end

  let(:undefined) do
    instance_double(
      RSpec::Lint::Double,
      invoked_selectors:   %i[c],
      defined_selectors:   %i[],
      definition_location: '/src/two.rb'
    )
  end

  let(:correct) do
    instance_double(
      RSpec::Lint::Double,
      invoked_selectors:   [],
      defined_selectors:   [],
      definition_location: '/src/three.rb'
    )
  end

  it 'yields doubles with unused or unspecified selectors' do
    expect { |rspec_probe| hijack.mismatched_definitions(&rspec_probe) }
      .to yield_successive_args(
        RSpec::Lint::Double::Lifetime.new([unused]),
        RSpec::Lint::Double::Lifetime.new([undefined])
      )
  end

  it 'wraps doubles' do
    expect(hijack.wrap_double(original, [args], stack))
      .to be_an_instance_of(RSpec::Lint::Double::Wrapper)
  end

  describe '#included' do
    let(:hijacker) { described_class.new(history)     }
    let(:history)  { described_class::History.new([]) }

    let(:hijacked_module) do
      hijacker = hijacker()

      Module.new do
        include hijacker

        def public_hijacker
          double_hijack
        end

        def instance_double(*arguments)
          [:original_implementation, arguments]
        end

        private

        def caller_locations
          ['/foo/bar.rb']
        end
      end
    end

    let(:extended_class) do
      Class.new.include(hijacked_module)
    end

    it 'does not publicly expose the hijacker' do
      expect(extended_class.new.respond_to?(:double_hijack)).to be(false)
    end

    it 'wraps the original instance double implementation' do
      expected =
        RSpec::Lint::Double.new(
          definition: [:some_argument],
          recorder:   RSpec::Lint::Double::Recorder.new,
          stack:      ['/foo/bar.rb'],
          original:   [:original_implementation, [:some_argument]]
        )

      expect(history).to receive(:add).with(expected).and_call_original

      extended_class.new.instance_double(:some_argument)
    end
  end
end
