# frozen_string_literal: true

RSpec.describe RSpec::Lint::Double::Hijack::History do
  subject(:history) { described_class.new([]) }

  def linted_double(*arguments)
    instance_double(
      RSpec::Lint::Double,
      definition_location: RSpec::Lint::Double::SourceLocation.new(*arguments)
    )
  end

  it 'groups double instances by definition location' do
    double1, double2, double3 = doubles = [
      linted_double('/foo/bar.rb', 1),
      linted_double('/foo/bar.rb', 1),
      linted_double('/foo/bar.rb', 2)
    ]

    doubles.each(&history.method(:add))

    expect(history.doubles).to eql([
      RSpec::Lint::Double::Lifetime.new([double1, double2]),
      RSpec::Lint::Double::Lifetime.new([double3])
    ])
  end
end
