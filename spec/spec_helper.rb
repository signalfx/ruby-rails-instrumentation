require 'bundler/setup'
require 'rails/instrumentation'
require 'opentracing_test_tracer'
# require 'rack/test'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def test_class_events(subscriber_class)
  subscriber_class::EVENTS.each do |event|
    expect(subscriber_class).to respond_to event
  end
end

class TestSubscriber
  include Rails::Instrumentation::Subscriber

  EVENTS = %w[ test_event_1 test_event_2 test_event_3 ]
  EVENT_NAMESPACE = 'test_subscriber'

  def self.subscribers
    @subscribers
  end

  def self.test_event_1(event)
  end

  def self.test_event_2(event)
  end

  def self.test_event_3(event)
  end
end

