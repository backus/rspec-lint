# frozen_string_literal: true

RSpec.describe RSpec::Lint::Double::Lifetime do
  subject(:lifetime) do
    described_class.new([first_linted_double, second_linted_double])
  end

  let(:first_linted_double) do
    instance_double(
      RSpec::Lint::Double,
      invoked_selectors:   %i[foo],
      defined_selectors:   %i[foo norf],
      definition_location: 'foo/bar.rb:1'
    )
  end

  let(:second_linted_double) do
    instance_double(
      RSpec::Lint::Double,
      invoked_selectors: %i[baz],
      defined_selectors: %i[foo norf]
    )
  end

  it 'exposes a shared definition location' do
    expect(lifetime.definition_location).to eql('foo/bar.rb:1')
  end

  it 'exposes unused selectors' do
    expect(lifetime.unused_selectors).to eql(Set.new(%i[norf]))
  end

  it 'exposes unspecified selectors' do
    expect(lifetime.unspecified_selectors).to eql(Set.new(%i[baz]))
  end

  context 'when all defined selectors are used' do
    subject(:lifetime) do
      described_class.new([
        instance_double(
          RSpec::Lint::Double,
          invoked_selectors: %i[foo],
          defined_selectors: %i[foo]
        )
      ])
    end

    it 'classifies the lifetime as having expected usage' do
      expect(lifetime.expected_usage?).to be(true)
    end
  end
end
