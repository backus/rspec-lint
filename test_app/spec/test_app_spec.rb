# frozen_string_literal: true
require_relative 'spec_helper'

RSpec.describe TestApp do
  it 'defines a double on SomeObject but only uses #foo and not #bar' do
    some_obj = instance_double(described_class::SomeObject, foo: 100, bar: 200)

    expect(some_obj.foo).to be(100)
  end

  it 'defines a double ot SomeObject and uses all of the methods' do
    some_obj = instance_double(described_class::SomeObject, foo: 100)

    expect(some_obj.foo).to be(100)
  end

  it 'ignores spies until they are supported' do
    some_obj = instance_spy(described_class::SomeObject)

    expect(some_obj.foo).to be(some_obj)
  end

  context 'when an allow is used it is ignored until it is supported' do
    let(:some_obj) { instance_double(described_class::SomeObject) }

    before do
      allow(some_obj).to receive(:foo).and_return(100)
      allow(some_obj).to receive(:bar).and_return(1)
    end

    it 'uses foo' do
      allow(some_obj).to receive(:foo).and_return(100)

      expect(some_obj.foo).to be(100)
    end

    it 'uses bar' do
      allow(some_obj).to receive(:bar).and_return(1)

      expect(some_obj.bar).to be(1)
    end
  end
end
