require 'rails/instrumentation/version'
require 'rails/instrumentation/subscriber'
require 'rails/instrumentation/subscribers/action_controller_subscriber'
require 'rails/instrumentation/subscribers/action_view_subscriber'
require 'rails/instrumentation/subscribers/active_record_subscriber'
require 'rails/instrumentation/utils'

require 'opentracing'
# require_relative 'instrumentation/subscriber'
# require_relative 'instrumentation/action_controller_subscriber'
# require_relative 'instrumentation/action_view_subscriber'
# require_relative 'instrumentation/active_record_subscriber'

module Rails
  module Instrumentation
    class Error < StandardError; end

    class << self

      attr_accessor :tracer

      def instrument(tracer: OpenTracing.global_tracer)
        @tracer = tracer
        @subscriber_mutex = Mutex.new

        add_subscribers
      end

      def add_subscribers
        @subscriber_mutex.synchronize do
          # ActionControllerSubscriber.subscribe
          ActionViewSubscriber.subscribe
          # ActiveRecordSubscriber.subscribe
        end
      end

      # this method takes an event payload and a hash of { :payload_identifier => 'opentracing.tag' }.
      # These payload values will be tagged on the span with the matching tag name
      def trace_notification(event, payload_tags: {})
        event = ::ActiveSupport::Notifications::Event.new(*event)
        puts event.payload.keys

        # build the tags from desired payload fields
        tags = {}
        payload_tags.each do |key, value|
          tags[value] = event.payload.fetch(key, 'unknown').to_s
        end

        span = @tracer.start_span(event.name.to_s, tags: tags, start_time: event.time)
        span.finish(end_time: event.end)
      end
    end
  end
end
