# frozen_string_literal: true

require 'bundler/setup'
require 'simplecov'
require 'i18n'
SimpleCov.start do
  add_filter '/spec/'
  minimum_coverage 95
end

require 'codebreaker'

I18n.load_path << Dir[File.expand_path('lib/config/locales/') + '/*.yml']

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
