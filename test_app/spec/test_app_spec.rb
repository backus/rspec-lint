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
end
