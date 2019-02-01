require 'bundler/setup'
require 'rails/instrumentation'
require 'opentracing_test_tracer'
# require 'rack/test'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

class TestSubscriber
  include Rails::Instrumentation::Subscriber

  EVENTS = [ 'test_event_1' ]
  EVENT_NAMESPACE = 'test_subscriber'

  def self.subscribers
    @subscribers
  end

  def self.test_event_1(event)
  end
end

