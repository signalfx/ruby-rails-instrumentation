require 'bundler/setup'
require 'rails/instrumentation'
require 'opentracing_test_tracer'
# require 'rack/test'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
