# frozen_string_literal: true
require 'open3'

RSpec.describe 'test app' do
  let(:stdout) { lint_test_app.first }
  let(:status) { lint_test_app[2]    }

  let(:lint_test_app) do
    Open3.capture3('bin/rspec-lint --no-color --format progress --order defined test_app/spec')
  end

  it 'reports unused definition' do
    aggregate_failures('successful linting') do
      expect(status.success?).to be(true)
      expect(stdout.split(/0 failures\n\n/).last).to eql(<<~OUTPUT)
      /Users/johnbackus/Projects/rspec-lint/test_app/spec/test_app_spec.rb:6
        Defined but not used: [:bar]
        Used but not defined: []


      OUTPUT
    end
  end
end
