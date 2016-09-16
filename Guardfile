# frozen_string_literal: true
module RSpecMapper
  class Mapping
    def initialize(match_result)
      @match_result = match_result
    end

    GLOB_TEMPLATE = 'spec/%{match}{/**/*,}_spec.rb'

    def self.yellow(text)
      "\e[0;33;49m#{text}\e[0m"
    end
    private_class_method(:yellow)

    REPORT_TEMPLATE = <<~REPORT
      Detected a file change for #{yellow('%<source_file>s')}
      Searched for tests matching #{yellow('%<spec_file_glob>s')}
      No matches found
    REPORT

    REPORTED_ATTRIBUTES = %i[source_file spec_file_glob files].freeze

    def files
      Dir[spec_file_glob]
    end

    def no_match_report
      format(REPORT_TEMPLATE, report_details)
    end

    private

    attr_reader :match_result

    def source_file
      match_result[0]
    end

    def captured_path
      match_result[1]
    end

    def spec_file_glob
      format(GLOB_TEMPLATE, match: captured_path)
    end

    def report_details
      values =
        REPORTED_ATTRIBUTES.map do |attribute|
          __send__(attribute).inspect
        end

      REPORTED_ATTRIBUTES.zip(values).to_h
    end
  end # Mapping

  def self.expand_match(guard_matches)
    mapping = Mapping.new(guard_matches)

    if mapping.files.empty?
      warn mapping.no_match_report
      %w[spec]
    else
      mapping.files
    end
  end

  def self.to_proc
    public_method(:expand_match).to_proc
  end
end # RSpecMapper

guard :rspec, cmd: 'bundle exec rspec --order defined --format documentation' do
  # Match all ruby files not in the spec directory
  watch(/\Alib\/(.+)\.rb\z/, &RSpecMapper)

  watch(/\Aspec.+\.rb/)
end
