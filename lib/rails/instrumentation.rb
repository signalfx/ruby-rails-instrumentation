require 'rails/instrumentation/version'

require 'rails/instrumentation/action_controller_subscriber'

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
      end

      def trace_event(event)
        puts event
      end
    end
  end
end
