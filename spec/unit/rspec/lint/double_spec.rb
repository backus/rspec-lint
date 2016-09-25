# frozen_string_literal: true
RSpec.describe RSpec::Lint::Double do
  subject(:linted_double) do
    described_class.new(
      definition: definition,
      recorder:   RSpec::Lint::Double::Recorder.new,
      stack:      stack,
      original:   double(*definition) # rubocop:disable RSpec/VerifiedDoubles
    )
  end

  let(:definition) { [:some_name, foo: 1] }

  let(:stack) do
    [
      instance_double(Thread::Backtrace::Location, path: '/foo/bar.rb', lineno: 1),
      instance_double(Thread::Backtrace::Location)
    ]
  end

  it 'exposes the path to the first location in the backtrace' do
    expect(linted_double.definition_location.to_s).to eql('/foo/bar.rb:1')
  end

  it 'provides a wrapped double with a recorder' do
    linted_double.wrapper.foo

    expect(linted_double.invoked_selectors).to eql(%i[foo])
  end

  it 'exposes the defined selectors for the double' do
    expect(linted_double.defined_selectors).to eql(%i[foo])
  end

  context 'when the definition does not defined any methods' do
    let(:definition) { [:some_name] }

    it 'does not register any method definitions' do
      expect(linted_double.defined_selectors).to eql([])
    end
  end
end
