# frozen_string_literal: true

RSpec.describe RSpec::Lint::Let do
  let(:mixin) { described_class.new }

  let(:example_group) do
    Class.new(RSpec::Core::ExampleGroup)
  end

  let(:rspec_describe) do
    example_group.describe do
      def use_foo
        foo
      end
    end
  end

  before do
    example_group.extend(mixin)
    rspec_describe.let(:foo) { 1 }
    rspec_describe.let(:bar) { 2 }
  end

  it 'hijacks let definitions' do
    expect(mixin.definitions).to eql(
      "#{__FILE__}:20:in `block (2 levels) in <top (required)>'" => :foo,
      "#{__FILE__}:21:in `block (2 levels) in <top (required)>'" => :bar
    )
  end

  it 'hijacks let invocations' do
    rspec_describe.new.use_foo

    expect(mixin.definitions).to eql(
      "#{__FILE__}:21:in `block (2 levels) in <top (required)>'" => :bar
    )
  end

  it 'passes through the return of the original let' do
    expect(rspec_describe.new.use_foo).to be(1)
  end
end
