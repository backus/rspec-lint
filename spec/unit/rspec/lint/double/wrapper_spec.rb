# frozen_string_literal: true
RSpec.describe RSpec::Lint::Double::Wrapper do
  subject(:wrapper) { described_class.new(recorder, test_double) }

  let(:foo)         { double(:foo)                      }
  let(:test_double) { double(:test_double, foo: foo)    }
  let(:recorder)    { RSpec::Lint::Double::Recorder.new }

  it 'records invocations' do
    expect { wrapper.foo }
      .to change(recorder, :invoked_selectors).from([]).to(%i[foo])
  end

  it 'returns original value' do
    expect(wrapper.foo).to equal(foo)
  end

  it 'records method invocations with arguments and a block on wrapped doubles' do
    passed_block = proc {}

    wrapper.foo(:bar, 1, &passed_block)

    expect(recorder.history).to eql([
      RSpec::Lint::Double::Recorder::MethodInvocation.new(
        selector:  :foo,
        arguments: [:bar, 1],
        block:     passed_block
      )
    ])
  end

  it 'responds to methods that the wrapped value responds to' do
    expect(wrapper.respond_to?(:foo)).to be(true)
  end

  it 'does not respond to methods that the wrapped value does not respond to' do
    expect(wrapper.respond_to?(:bar)).to be(false)
  end
end
