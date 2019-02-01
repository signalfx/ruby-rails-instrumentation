require 'rails/instrumentation/version'
require 'rails/instrumentation/subscriber'
require 'rails/instrumentation/subscribers/action_controller_subscriber'
require 'rails/instrumentation/subscribers/action_view_subscriber'
require 'rails/instrumentation/subscribers/active_record_subscriber'
require 'rails/instrumentation/utils'

require 'opentracing'

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
          ActionControllerSubscriber.subscribe
          ActionViewSubscriber.subscribe
          ActiveRecordSubscriber.subscribe
        end
      end
    end
  end
end
