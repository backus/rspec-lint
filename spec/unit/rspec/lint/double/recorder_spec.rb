# frozen_string_literal: true

RSpec.describe RSpec::Lint::Double::Recorder do
  subject(:recorder) { described_class.new }

  let(:method_name) { instance_double(Symbol) }
  let(:arguments)   { instance_double(Array)  }
  let(:block)       { instance_double(Proc)   }

  before do
    recorder.record(method_name, arguments, block)
  end

  it 'exposes invoked method selectors' do
    expect(recorder.invoked_selectors).to eql([method_name])
  end

  it 'exposes a history of method invocations' do
    expect(recorder.history.first).to eql(
      described_class::MethodInvocation.new(
        selector:  method_name,
        arguments: arguments,
        block:     block
      )
    )
  end

  it 'freezes the history' do
    expect(recorder.history.frozen?).to be(true)
  end
end
