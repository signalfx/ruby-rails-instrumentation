require 'rails/instrumentation/version'
require 'rails/instrumentation/subscriber'
require 'rails/instrumentation/subscribers/action_controller_subscriber'
require 'rails/instrumentation/subscribers/action_view_subscriber'
require 'rails/instrumentation/subscribers/active_record_subscriber'

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

        @subscriber_mutex.synchronize do
          add_subscribers
        end
      end

      def add_subscribers
        ActionControllerSubscriber.subscribe
        ActionViewSubscriber.subscribe
        ActiveRecordSubscriber.subscribe
      end

      def trace_notification(event, tag_list = nil)
        puts event[0], event[1], event[2], event[3]
        event = ::ActiveSupport::Notifications::Event.new(*event)
        span = @tracer.start_span(event.name.to_s, start_time: event.time)
        span.finish(end_time: event.end)
      end
    end
  end
end
